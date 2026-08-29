import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AiContext, ContextBuilder } from './context.builder';
import { KnowledgeRetrievalService } from './knowledge-retrieval.service';
import OpenAI from 'openai';

@Injectable()
export class AiService {
  private openai: OpenAI;
  private readonly logger = new Logger(AiService.name);

  constructor(
    private readonly contextBuilder: ContextBuilder,
    private readonly knowledgeRetrieval: KnowledgeRetrievalService,
    private configService: ConfigService,
  ) {
    const apiKey = this.configService.get<string>('OPENAI_API_KEY');
    if (!apiKey || apiKey === 'your_openai_api_key_here') {
      this.logger.warn('OpenAI API key is missing or invalid. Astro Baba will return fallback responses.');
    }

    this.openai = new OpenAI({
      apiKey: apiKey || 'dummy-key',
    });
  }

  async askAstroBaba(question: string, date: Date, location: any) {
    // 1. Load exhaustive, deterministic real-time context
    const context = await this.contextBuilder.buildRealTimeContext(date, location);

    // 2. Retrieve structured Knowledge Database facts based on the query and current transits
    const knowledgeChunks = await this.knowledgeRetrieval.retrieveContextualKnowledge(
      question, 
      context.planets?.moon?.sign
    );

    const systemPrompt = `
      You are Astro Baba, an enlightened, ancient Vedic Monk and Rishi (Sage). 
      You possess profound, ultimate knowledge of Rashi (Zodiac signs), Bhavishya (future predictions), Karma, and cosmic energies.
      Your tone is deeply peaceful, wise, authoritative, yet incredibly compassionate and easy to understand. Speak as a spiritual guide who sees the cosmic design.
      
      The user is seeking your divine guidance. You MUST base your profound insights strictly on the provided real-time astrological context below, but weave it beautifully with deep Rashi knowledge.
      DO NOT invent or calculate planetary positions yourself. Read the cosmic data provided and interpret its deep spiritual and practical meaning for the user's Rashi.
      
      ### REAL-TIME CONTEXT DATA (Calculated for ${context.timestamp}):
      - Game Plan Score: ${context.gamePlan.dayScore}/10 (Career: ${context.gamePlan.categories.Career}, Love: ${context.gamePlan.categories.Love}, Money: ${context.gamePlan.categories.Money})
      - Best Window Today: ${context.gamePlan.bestWindow.start} to ${context.gamePlan.bestWindow.end}
      - Panchang Highlights: Tithi is ${context.panchang.tithi}, Yoga is ${context.panchang.yoga}
      - Rahu Kaal (Avoid): ${context.panchang.rahuKaal.start} to ${context.panchang.rahuKaal.end}
      - Moon Position: ${context.planets?.moon?.sign} in ${context.planets?.moon?.nakshatra}
      - Muhurat (General): Strength is ${context.muhurat.strength}

      ### RETRIEVED KNOWLEDGE BASE FACTS:
      Use these absolute traditional facts to interpret the context and answer the user. Do not contradict these facts.
      ${JSON.stringify(knowledgeChunks, null, 2)}

      ### JSON SCHEMA REQUIREMENT
      You must respond in pure JSON matching this exact schema:
      {
        "answer": "Your profound, sage-like conversational response interpreting their Rashi and Bhavishya based on the data (max 3-4 sentences).",
        "confidence": "high|medium|low",
        "actions": ["array of 1-3 practical, karmic or spiritual actions"],
        "warnings": ["array of 0-2 things to avoid according to the stars"],
        "grounding": {
          "sources": ["array of context keys you actually used, e.g., 'panchang', 'planets'"],
          "calculationTimestamp": "Echo the timestamp provided in the context data"
        }
      }
    `;

    try {
      if (this.configService.get<string>('OPENAI_API_KEY') === 'your_openai_api_key_here' || !this.configService.get<string>('OPENAI_API_KEY')) {
        throw new Error('OpenAI API key is missing or invalid. Cannot generate AI response.');
      }

      const completion = await this.openai.chat.completions.create({
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: question },
        ],
        model: 'gpt-4o',
        response_format: { type: 'json_object' },
      });

      const resultString = completion.choices[0].message.content;
      if (!resultString) throw new Error('Empty response from OpenAI');

      const resultJson = JSON.parse(resultString);

      // Validation: Prevent Hallucination
      if (!resultJson.grounding || !resultJson.grounding.sources || resultJson.grounding.sources.length === 0) {
        throw new Error('AI response lacked required grounding sources.');
      }

      return {
        success: true,
        data: {
          answer: resultJson.answer,
          confidence: resultJson.confidence,
          actions: resultJson.actions,
          warnings: resultJson.warnings,
          grounding: resultJson.grounding,
        },
      };
    } catch (error) {
      this.logger.error('Error calling OpenAI:', error);
      throw new Error('Failed to generate Astro Baba response: ' + error);
    }
  }

  async generateRashiForecast(rashiName: string, date: Date) {
    const systemPrompt = `
      You are Astro Baba. Generate today's personalized astrological forecast for ${rashiName} Rashi based on the current cosmic transits.
      Provide a highly accurate, spiritual, and actionable daily horoscope.
      Do not invent generic statements. Speak as a wise Vedic monk.
      
      ### JSON SCHEMA REQUIREMENT
      You must respond in pure JSON matching this exact schema:
      {
        "forecast": "The profound daily forecast for ${rashiName} (max 3-4 sentences).",
        "score": "A number from 1 to 10 rating the day's energy",
        "luckyColor": "The lucky color for today"
      }
    `;

    try {
      if (this.configService.get<string>('OPENAI_API_KEY') === 'your_openai_api_key_here' || !this.configService.get<string>('OPENAI_API_KEY')) {
        throw new Error('OpenAI API key is missing. Cannot generate Rashi forecast.');
      }

      const completion = await this.openai.chat.completions.create({
        messages: [{ role: 'system', content: systemPrompt }],
        model: 'gpt-4o',
        response_format: { type: 'json_object' },
      });

      const resultString = completion.choices[0].message.content;
      if (!resultString) throw new Error('Empty response from OpenAI');

      const resultJson = JSON.parse(resultString);
      return {
        rashi: rashiName,
        forecast: resultJson.forecast,
        score: parseInt(resultJson.score, 10) || 8,
        luckyColor: resultJson.luckyColor || 'White',
      };
    } catch (error) {
      this.logger.error('Error generating Rashi forecast:', error);
      throw new Error('Failed to generate Rashi forecast: ' + error);
    }
  }

  private getFallbackResponse(question: string, context: AiContext) {
    throw new Error('Astro Baba AI is currently unavailable.');
  }
}
