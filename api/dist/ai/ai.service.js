"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
var AiService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AiService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const context_builder_1 = require("./context.builder");
const openai_1 = __importDefault(require("openai"));
let AiService = AiService_1 = class AiService {
    constructor(contextBuilder, configService) {
        this.contextBuilder = contextBuilder;
        this.configService = configService;
        this.logger = new common_1.Logger(AiService_1.name);
        const apiKey = this.configService.get('OPENAI_API_KEY');
        if (!apiKey || apiKey === 'your_openai_api_key_here') {
            this.logger.warn('OpenAI API key is missing or invalid. Astro Baba will return fallback responses.');
        }
        this.openai = new openai_1.default({
            apiKey: apiKey || 'dummy-key',
        });
    }
    async askAstroBaba(question, date, location) {
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
            if (this.configService.get('OPENAI_API_KEY') === 'your_openai_api_key_here' || !this.configService.get('OPENAI_API_KEY')) {
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
            if (!resultString)
                throw new Error('Empty response from OpenAI');
            const resultJson = JSON.parse(resultString);
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
        }
        catch (error) {
            this.logger.error('Error calling OpenAI:', error);
            return this.getFallbackResponse(question, context);
        }
    }
    getFallbackResponse(question, context) {
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
};
exports.AiService = AiService;
exports.AiService = AiService = AiService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [context_builder_1.ContextBuilder,
        config_1.ConfigService])
], AiService);
//# sourceMappingURL=ai.service.js.map