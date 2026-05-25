![[Pasted image 20260517123758.png]]

It uses an LLM to select an action, executes that action, evaluates the result, and repeats the process until the task is complete. Let’s take a closer look at each of these components:

- Brain: The LLM is the core. It reads the situation, thinks, and decides what to do next. The big shift from chatbot to agent: the model isn't writing text anymore, it's making choices.
    
- Planning: Hard tasks need more than one step. Agents break them down using methods like Chain of Thought (think step by step), Tree of Thoughts (try options, pick the best), or  
    Reflexion (learn from mistakes and retry). Planning turns a fuzzy goal into clear actions.
    
- Tools: An LLM without tools is a brain in a jar. Tools are functions the model can call, like web search, code execution, APIs, files, or browsers (often using the MCP standard). The model requests a tool, the system runs it, and the result comes back.
    
- Memory: Without memory, every turn starts from zero. Short-term memory is the context window. Long-term memory lives in vector stores, files, and knowledge bases. When the window fills up, agents summarize old turns and carry the summary forward.
    
- Loop: All four pieces work together in a cycle. The agent looks at the current state, decides what to do, uses a tool, sees the result, and repeats. It keeps going until it gives a final answer.
    
- Guardrails: Not strictly anatomy, but important. Sandboxing, human checks, token limits, output validation, and scope limits keep autonomy from turning into expensive chaos. The more autonomy you give, the more these matter.