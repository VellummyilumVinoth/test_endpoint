import ballerinax/ai.openai;

final openai:ModelProvider mathTutorModel = check new (accessToken, openai:GPT_4O_MINI);
