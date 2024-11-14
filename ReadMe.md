# Visualising Phases of a Compiler

This project demonstrates the various phases of a compiler, including lexical analysis, syntax analysis, intermediate code generation, optimization, and target code generation. The project is implemented using C and Yacc/Lex tools to provide a comprehensive understanding of how a compiler processes source code.

## Purpose

The purpose of this project is to visualize and understand the different stages a compiler goes through to transform high-level source code into optimized machine code. It covers the following phases:
1. Lexical Analysis
2. Syntax Analysis
3. Intermediate Code Generation
4. Code Optimization
5. Target Code Generation

## Key Features

- **Lexical Analysis**: Tokenizes the input source code using `lexer.l`.
- **Syntax Analysis**: Parses the tokenized input to generate an Abstract Syntax Tree (AST) using `parse.y`.
- **Intermediate Code Generation**: Converts the AST into three-address code using `intermediateCode.c`.
- **Code Optimization**: Optimizes the three-address code to remove redundancies using `optimiser.y`.
- **Target Code Generation**: Translates the optimized code into target assembly code using `codeGenerator.c`.

## Installation

To build and run the project, you need to have `gcc`, `yacc`, and `lex` installed on your system. Follow the steps below to set up the project:

1. Clone the repository:
    ```sh
    git clone <repository-url>
    cd <repository-directory>
    ```

2. Compile the lexer and parser:
    ```sh
    lex lexer.l
    yacc -d parse.y
    gcc lex.yy.c y.tab.c -o parser -ll
    ```

3. Compile the intermediate code generator:
    ```sh
    gcc intermediateCode.c -o intermediateCode
    ```

4. Compile the optimizer:
    ```sh
    yacc -d optimiser.y
    gcc y.tab.c -o optimiser -ly
    ```

5. Compile the code generator:
    ```sh
    gcc codeGenerator.c -o codeGenerator
    ```

## Usage

### Lexical and Syntax Analysis

1. Run the parser to perform lexical and syntax analysis:
    ```sh
    ./parser < input.c
    ```

### Intermediate Code Generation

1. Run the intermediate code generator:
    ```sh
    ./intermediateCode
    ```

### Code Optimization

1. Run the optimizer:
    ```sh
    ./optimiser
    ```

### Target Code Generation

1. Run the code generator:
    ```sh
    ./codeGenerator
    ```

## Example

Here is an example of how to use the project:

1. Create an input file `input.c` with the following content:
    ```c
    int main() {
    int x = 5;
    if(x > 3) {
        return x;
    }
    return 0;
    }
    ```

2. Run the parser:
    ```sh
    ./parser input.c
    ```

3. Run the intermediate code generator:
    ```sh
    ./intermediateCode
    ```

4. Run the optimizer:
    ```sh
    ./optimiser
    ```

5. Run the code generator:
    ```sh
    ./codeGenerator
    ```
6. Generate and view the AST tree:
    ```sh
    dot -Tpng ast_tree.dot -o ast_tree.png
    eog ast_tree.png
    ```
## Relevant Information

- The project uses `lexer.l` for lexical analysis, `parse.y` for syntax analysis, `intermediateCode.c` for intermediate code generation, `optimiser.y` for code optimization, and `codeGenerator.c` for target code generation.
- The intermediate code is represented in three-address code format.
- The optimizer removes redundant operations such as multiplication by 1 and addition of 0.
- The target code is generated in a simple assembly-like format.

## Contributors

<a href="https://github.com/antrxc"><img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/132219079?v=4" width="100" height="100" alt="antrxc"/></a>
<a href="https://github.com/Arthi-Ramasamy"><img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/153719767?v=4" width="100" height="100" alt="Arthi-Ramasamy"/></a>