# calculator_app

### Basic calculator app built using Flutter.

## Features

- The **C/AC** button removes the last entry from the expression with a **single tap** if inputs are still being entered, or clears the entire result if it’s currently displayed. A **long tap** will always clear the entire expression.
- Attempting to enter a number after the result is displayed will clear the result and start a new expression.
- Operators are displayed in the expression as they are entered, but are not evaluated until the **=** button is pressed.
- Operators can be entered after the result is displayed to continue the expression.
- Attempting to enter an operator after another operator will replace the previous one.
- The **=** button evaluates the expression and displays the result.
- Entering a decimal point is prevented if the current number already contains one.
- If a number ends with a decimal point, it is removed before evaluating the expression.
- Entering a decimal point directly after an operator will append a **0** before it.
- Entering a number while the initial **0** is displayed will replace it.
- The user is prevented from entering more than one **0** at the beginning of a number.
- The user is allowed to press the expression text field to edit the expression, and upon submitting (hitting enter) or pressing the **=** button, the expression will be evaluated.
