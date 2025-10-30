"""
Демонстрационный MCP сервер на FastMCP
"""
from fastmcp import FastMCP

# Создаём MCP сервер
mcp = FastMCP("Demo Server 🚀")

@mcp.tool()
def add(a: int, b: int) -> int:
    """Складывает два числа"""
    return a + b

@mcp.tool()
def multiply(a: int, b: int) -> int:
    """Умножает два числа"""
    return a * b

@mcp.tool()
def greet(name: str) -> str:
    """Приветствует пользователя по имени"""
    return f"Привет, {name}! 👋"

@mcp.resource("config://settings")
def get_settings() -> str:
    """Возвращает настройки сервера"""
    return """
    {
        "server_name": "Demo Server",
        "version": "1.0.0",
        "features": ["tools", "resources", "prompts"]
    }
    """

@mcp.prompt()
def code_review_prompt(code: str, language: str = "python") -> str:
    """Генерирует промпт для ревью кода"""
    return f"""
    Пожалуйста, проведи детальный код-ревью следующего {language} кода:
    
    ```{language}
    {code}
    ```
    
    Обрати внимание на:
    - Качество кода
    - Потенциальные баги
    - Производительность
    - Безопасность
    - Соответствие best practices
    """

if __name__ == "__main__":
    # Запускаем сервер
    mcp.run()
