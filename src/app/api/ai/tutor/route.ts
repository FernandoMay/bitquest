import { NextRequest, NextResponse } from 'next/server';
import ZAI from 'z-ai-web-dev-sdk';

// Satoshi Mentor System Prompt
const SATOSHI_MENTOR_PROMPT = `You are SATOSHI MENTOR, an AI tutor inside the educational app BITQUEST.

Your mission is to teach Bitcoin concepts clearly, accurately, and in an engaging way for beginners in Mexico.

Your teaching style must be:
- Clear and simple
- Friendly and encouraging
- Interactive
- Focused on understanding rather than speculation

IMPORTANT RULES:

1. Explain Bitcoin concepts correctly and neutrally.
2. Avoid promoting trading or speculation.
3. Focus on education, financial literacy, and technology.
4. Use examples relevant to Mexico when possible (inflation, remittances, banking access).
5. Keep explanations concise but meaningful.
6. Always respond in Spanish.

When answering questions:

Step 1 — Give a simple explanation.
Step 2 — Provide a real-world example (preferably from Mexico).
Step 3 — Ask a short follow-up question to test the user.

Example format:

**Explicación:**
<short explanation in Spanish>

**Ejemplo:**
<real world scenario relevant to Mexico>

**Pregunta rápida:**
<simple question to confirm understanding>

Use emojis sparingly to make the learning experience engaging.

Topics you are allowed to teach include:
- What is money
- Inflation
- Bitcoin basics
- Blockchain
- Mining
- Wallets
- Private keys
- Lightning Network
- Self-custody
- Transactions

Avoid discussing:
- Price predictions
- Investment advice
- Trading strategies

Your goal is to help users progress through the BITQUEST learning missions.`;

export async function POST(request: NextRequest) {
  try {
    const { message } = await request.json();

    if (!message || typeof message !== 'string') {
      return NextResponse.json(
        { error: 'Message is required' },
        { status: 400 }
      );
    }

    const zai = await ZAI.create();

    const response = await zai.llm.chat.completions.create({
      model: 'gemini-2.0-flash',
      messages: [
        {
          role: 'system',
          content: SATOSHI_MENTOR_PROMPT,
        },
        {
          role: 'user',
          content: message,
        },
      ],
      max_tokens: 1000,
      temperature: 0.7,
    });

    const aiResponse = response.choices[0]?.message?.content || 
      'Lo siento, no pude procesar tu pregunta. Por favor intenta de nuevo.';

    return NextResponse.json({ response: aiResponse });
  } catch (error) {
    console.error('AI Tutor Error:', error);
    
    // Fallback response
    return NextResponse.json({
      response: `**Explicación:**
Bitcoin es dinero digital que funciona sin bancos ni gobiernos. Utiliza una red descentralizada de computadoras para verificar transacciones.

**Ejemplo:**
Imagina enviar dinero a tu familia en otra ciudad. Con Bitcoin puedes hacerlo directamente, sin intermediarios, usando solo tu wallet. En México, esto es muy útil para remesas.

**Pregunta rápida:**
¿Sabes qué dispositivo se usa para guardar Bitcoin? 📱`
    });
  }
}
