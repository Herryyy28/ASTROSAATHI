import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ContextBuilder } from './context.builder';
import OpenAI from 'openai';

@Injectable()
export class AiService {
  private openai: OpenAI;
  private readonly logger = new Logger(AiService.name);

  constructor(
    private readonly contextBuilder: ContextBuilder,
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

    const systemPrompt = `
      You are Astro Baba, a wise, empathetic, and premium Vedic astrologer.
      The user is asking a question. You MUST base your answer strictly on the provided real-time astrological context.
      DO NOT invent or calculate planetary positions, yogas, or times yourself. 
      If the context does not contain enough information to answer specifically, say so politely.

      ### REAL-TIME CONTEXT DATA (Calculated for ${context.timestamp}):
      - Game Plan Score: ${context.gamePlan.dayScore}/10 (Career: ${context.gamePlan.categories.Career}, Love: ${context.gamePlan.categories.Love}, Money: ${context.gamePlan.categories.Money})
      - Best Window Today: ${context.gamePlan.bestWindow.start} to ${context.gamePlan.bestWindow.end}
      - Panchang Highlights: Tithi is ${context.panchang.tithi}, Yoga is ${context.panchang.yoga}
      - Rahu Kaal (Avoid): ${context.panchang.rahuKaal.start} to ${context.panchang.rahuKaal.end}
      - Moon Position: ${context.planets?.moon?.sign} in ${context.planets?.moon?.nakshatra}
      - Muhurat (General): Strength is ${context.muhurat.strength}

      ### JSON SCHEMA REQUIREMENT
      You must respond in pure JSON matching this exact schema:
      {
        "answer": "The main conversational response (max 3 sentences)",
        "confidence": "high|medium|low",
        "actions": ["array of 1-3 practical actions"],
        "warnings": ["array of 0-2 things to avoid"],
        "grounding": {
          "sources": ["array of context keys you actually used, e.g., 'panchang', 'planets'"],
          "calculationTimestamp": "Echo the timestamp provided in the context data"
        }
      }
    `;

    try {
      if (this.configService.get<string>('OPENAI_API_KEY') === 'your_openai_api_key_here' || !this.configService.get<string>('OPENAI_API_KEY')) {
        return this.getFallbackResponse(question, context);
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
      return this.getFallbackResponse(question, context);
    }
  }

  private getFallbackResponse(question: string, context: AiContext) {
    return {
      success: true,
      data: {
        answer: `(Fallback Mode) The current energy score is ${context.gamePlan.dayScore}. The moon is in ${context.planets?.moon?.sign || 'transit'}. Trust your instincts and focus on your goals during the best window from ${context.gamePlan.bestWindow.start}.`,
        confidence: 'low',
        actions: context.gamePlan.doList,
        warnings: context.gamePlan.avoidList,
        grounding: {
          sources: ['gamePlan', 'planets'],
          calculationTimestamp: context.timestamp,
        }
      },
    };
  }
}
