"""Smart Calculator with LLM Explanations"""

import from byllm.llm { Model }

#  model (gemini, verbose=False)

glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);

"""LLM explains the calculation step by step"""
def explain_calc(expression: str, result: int) -> str by llm();

walker CalcGame {
    has expression: str;   # user-entered expression

    can start with `root entry;
    can compute with turn entry;
}

node turn {
    has result: int;
}

with entry:__main__ {
    while True {
        expr = input("Enter a math expression (or 'quit' to exit): ");
        if expr.strip().lower() == "quit" {
            print("Goodbye!");
            break;
        }
        root spawn CalcGame(expr);
    }
}

impl CalcGame.start {
    try {
        result = eval(self.expression);   
        here = root ++> turn(result);
        visit here;
    } except Exception as e {
        print(f"Invalid expression: {e}");
        disengage;
    }
}

impl CalcGame.compute {
    print(f"Expression: {self.expression}");
    print(f"Result: {here.result}");
    # let the LLM explain the calculation
    print(explain_calc(self.expression, here.result));
    disengage;
}

