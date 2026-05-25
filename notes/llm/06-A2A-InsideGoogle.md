[source-blog](https://towardsdatascience.com/inside-googles-agent2agent-a2a-protocol-teaching-ai-agents-to-talk-to-each-other/?ref=dailydev)

Exploring how Google's A2A enables plug-and-play communication between LLM-powered agents across frameworks

## Why Can’t Our AI Agents Just Get Along?

Imagine you’ve hired a team of super-smart AI assistants. One is great at data analysis, another writes eloquent reports, and a third handles your calendar. Individually, they’re brilliant. But here’s the rub: they don’t speak the same language. It’s like having coworkers where one speaks only Python, another only JSON, and the third communicates in obscure API calls. Ask them to collaborate on a project, and you get a digital version of the Tower of Babel.

This is **exactly the problem Google’s Agent2Agent (A2A) Protocol aims to solve**. A2A is a new open standard (announced in April 2025) that gives AI agents a common language – a sort of universal translator — so they can **communicate and collaborate** seamlessly. It’s backed by an impressively large coalition (50+ tech companies including the likes of Atlassian, Cohere, Salesforce, and more) rallying behind the idea of agents chatting across platforms. In short, A2A matters because it promises to break AI agents out of their silos and let them work together like a well-coordinated team rather than isolated geniuses.


At its core, **A2A is a communication protocol for AI agents**. Think of it as a standardized **common language** that any AI agent can use to talk to any other agent, regardless of who built it or what framework it runs on. Today, there’s a “framework jungle” of agent-building tools — LangGraph, CrewAI, Google’s ADK, Microsoft’s Autogen, you name it. Without A2A, if you tried to make a LangGraph agent directly chat with a CrewAI agent, you’d be in for a world of custom integration pain (picture two software engineers frantically writing glue code so their bots can gossip). **Enter A2A**: it’s the **bridge that lets diverse agents share information, ask each other for help, and coordinate tasks** without custom duct-tape code.

In plainer terms, A2A does for AI agents what internet protocols did for computers — it gives them a **universal networking language**. An agent built in Framework A can send a message or task request to an agent built in Framework B, and thanks to A2A, B will understand it and respond appropriately. They don’t need to know the messy details of each other’s “internal brain” or code; A2A handles the translation and coordination. As Google put it, the A2A protocol lets agents “communicate with each other, securely exchange information, and coordinate actions” across different platforms. Crucially, agents do this **as peers, not as mere tools** — meaning each agent retains its autonomy and special skills while cooperating.

### A2A in Plain English: A Universal Translator for AI Coworkers

Let’s put on our imagination hats. Picture a busy office, but instead of humans, it’s populated by AI agents. We have Alice the Spreadsheet Guru, Bob the Email Whiz, and Carol the Customer Support bot. On a normal day, Alice might need Bob to send a client a summary of some data Carol provided. But Alice speaks Excel-ese, Bob speaks API-jsonish, and Carol speaks in natural language FAQs. Chaos ensues — Alice outputs a CSV that Bob doesn’t know how to read, Bob sends an email that Carol can’t parse, and Carol logs an issue that never gets back to Alice. It’s like a bad comedy of errors.

Now imagine **a magical conference room with real-time translation**. Alice says _“I need the latest sales figures”_ in Excel-ese; the translator (A2A) relays _“Hey Carol, can you get sales figures?”_ in Carol’s language; Carol fetches the data and speaks back in plain English; the translator ensures Alice hears it in Excel terms. Meanwhile, Bob chimes in automatically _“I’ll draft an email with those figures,”_ and the translator helps Bob and Carol coordinate on the content. Suddenly, our three AI coworkers are working together smoothly, each contributing what they do best, without misunderstanding.

**That translator is A2A.** It ensures that when one agent “talks,” the other can “hear” and respond appropriately, even if internally one is built with LangGraph and another with Autogen (AG2). A2A provides the **common language and etiquette for agents**: how to introduce themselves, how to ask another for help, how to exchange information, and how to politely say “Got it, here’s the result you wanted.” Just like a good universal translator, it handles the heavy lifting of communication so the agents can focus on the task at hand.

And yes, security folks, A2A has you in mind too. The protocol is designed to be **secure and enterprise-ready** from the get-go — authentication, authorization, and governance are built-in, so agents only share what they’re allowed to. Agents can work together **without exposing their secret sauce (internal memory or proprietary tools)** to each other It’s collaboration with privacy, kind of like doctors consulting on a case without breaching patient confidentiality.

## How Does A2A Work Under the Hood?

Okay, so A2A is like a lingua franca for AI agents — but what does that actually look like technically? Let’s peek (lightly) under the hood. The A2A protocol is built on familiar web technologies: it uses **JSON-RPC 2.0 over HTTP(S)** as the core communication method. In non-engineer speak, that means agents send each other **JSON-formatted messages** (containing requests, responses, etc.) via standard web calls. No proprietary binary goobledygook, just plain JSON over HTTP — which is great, because it’s like speaking in a language every web service already understands. It also supports nifty extras like **Server-Sent Events (SSE)** for streaming updates and **async callbacks** for notifications. So if Agent A asks Agent B a question that will take a while (maybe B has to crunch data for 2 minutes), B can stream partial results or status updates to A instead of leaving A hanging in silence. Real teamwork vibes there.

![[Pasted image 20260304171855.png]]

When Agent A wants Agent B’s help, A2A defines a clear process for this interaction. Here are the key pieces to know (without drowning in spec details):

- **Agent Card (Capability Discovery):** Every agent using A2A presents an **Agent Card** — basically a JSON “business card” describing who it is and what it can do. Think of it like a LinkedIn profile for an AI agent. It has the agent’s name, a description, a version, and importantly a list of **skills** it offers. For example, an Agent Card might say: _“I’m ‘CalendarBot v1.0’ — I can schedule meetings and check availability.”_ This lets other agents discover the right teammate for a task. Before Agent A even asks B for help, A can look at B’s card to see if B has the skills it needs. No more guessing in the dark!
- **Agent Skills:** These are the individual capabilities an agent has, as listed on its Agent Card. For instance, CalendarBot might have a skill `"schedule_meeting"` with a description “Schedules a meeting between participants given a date range.” Skills are defined with an ID, a human-friendly name, description, and even example prompts. It’s like listing out services you offer. This makes it clear what requests the agent can handle.
- **Tasks and Artifacts (Task Management):** When Agent A wants B to do something, it sends a **Task** request. A task is a structured JSON object (defined by the A2A protocol) that describes the job to be done. For example, _“Task: use your `schedule_meeting` skill with inputs X, Y, Z.”_ The two agents then engage in a dialog to get it done: B might reply with questions, intermediate results, or confirmations. Once finished, the outcome of the task is packaged into an **Artifact** — think of that as the deliverable or result of the task. If it was a scheduling task, the artifact might be a calendar invite or a confirmation message. Importantly, tasks have a lifecycle. Simple tasks might complete in one go, while longer ones stay “open” and allow back-and-forth updates. A2A natively supports **long-running tasks** — agents can keep each other posted with status updates (“Still working on it… almost done…”) over minutes or hours if needed. No timeouts ruining the party.
-  **Messages (Agent Collaboration):** The actual info exchanged between agents — context, questions, partial results, etc. — are sent as **messages**. This is essentially the conversation happening to accomplish the task. The protocol lets agents send different types of content within messages, not just plain text. They could share structured data, files, or even media. Each message can have multiple **parts**, each labeled with a content type. For instance, Agent B could send a message that includes a text summary _and_ an image (two parts: one “text/plain”, one “image/png”). Agent A will know how to handle each part. If Agent A’s interface can’t display images, A2A even allows them to negotiate a fallback (maybe B will send a URL or a text description instead). This is the **“user experience negotiation”** bit — ensuring the receiving side gets the content in a format it can use. It’s akin to two coworkers figuring out whether to share info via PowerPoint, PDF, or just an email, based on what each can open.
- **Secure Collaboration:** All this communication is done with security in mind. A2A supports standard authentication (API keys, OAuth, etc., similar to OpenAPI auth schemes) so that an agent doesn’t accept tasks from just anyone. Plus, as mentioned, agents don’t have to reveal their internal workings. Agent B can help Agent A without saying _“By the way, I’m powered by GPT-4 and here’s my entire prompt history.”_ They only exchange the necessary info (the task details and results), keeping proprietary stuff hidden. This **preserves each agent’s independence and privacy** — they cooperate, but they don’t merge into one big blob.

- In summary, A2A sets up a **client–server model between agents**: when Agent A needs something, it acts as a **Client Agent** and Agent B plays the **Remote Agent** (server) role. A2A handles how the client finds the right remote agent (via Agent Cards), how it sends the task (JSON-RPC message), how the remote agent streams responses or final results, and how both stay in sync throughout. All using web-friendly standards so it’s easy to plug into existing apps. If this sounds a bit like how web browsers talk to web servers (requests and responses), that’s no coincidence — A2A essentially applies similar concepts to _agents talking to agents_, which is a logical approach to maximize compatibility.

## A2A vs. MCP: Tools vs. Teammates

You might have also heard of **Anthropic’s Model Context Protocol (MCP)** — another recent open standard in the AI space. (If you haven’t already, take a look at [my other post on breaking down MCP](https://towardsdatascience.com/how-i-finally-understood-mcp-and-got-it-working-irl-2/) and how you can build your own custom MCP server from scratch). How does A2A relate to MCP? Are they competitors or friends? The short answer: **they’re complementary, like two pieces of a puzzle**. The long answer needs a quick analogy (of course!).

Think of an AI agent as a person trying to get a job done. This person has **tools** (like a calculator, web browser, database access) and may also have **colleagues** (other agents) to collaborate with. **MCP (Model Context Protocol)** is essentially about hooking up the **tools**. It standardizes how an AI agent accesses external tools, APIs, and data sources in a secure, structured way. For example, via MCP, an agent can use a “Calculator API” or “Database lookup API” as a plugin, with a common interface. _“Think of MCP like a USB-C port for AI — plug-and-play for tools,”_ as one description goes. It gives agents a uniform way to say _“I need X tool”_ and get a response, regardless of who made the tool.

![[Pasted image 20260304172043.png]]

**A2A, on the other hand, is about connecting with the **teammates****. It lets one autonomous agent talk to another as an equal partner. Instead of treating the other agent like a dumb tool, A2A treats it like a knowledgeable colleague. Continuing our analogy, A2A is the protocol you’d use when the person decides, _“Actually, I need Bob’s help on this task,”_ and turns to ask Bob (another agent) for input. Bob might then use his own tools (maybe via MCP) to assist, and reply back through A2A.

In essence, **MCP is how agents invoke tools, A2A is how agents invoke each other**. Tools vs. Teammates. One is like calling a function or using an app; the other is like having a conversation with a coworker. Both approaches often work **hand-in-hand**: an agent might use MCP to fetch some data and then use A2A to ask another agent to analyze that data, all within the same complex workflow. In fact, Google explicitly designed A2A to **complement** MCP’s functionality, not replace it.

## A2A vs. Existing Agent Orchestration Frameworks

If you’ve played with multi-agent systems already, you might be thinking: _“There are already frameworks like LangGraph, AutoGen, or CrewAI that coordinate multiple agents — how is A2A different?”_ Great question. The difference boils down to **protocol vs. implementation**.

Frameworks like **LangGraph, AutoGen, and CrewAI** are what we’d call **agent orchestration frameworks**. They provide higher-level structures or engines to design how agents work together. For instance, AutoGen (from Microsoft) lets you script conversations between agents (e.g., a “Manager” agent and a “Worker” agent) within a controlled environment. LangGraph (part of LangChain’s ecosystem) lets you build agents as nodes in a graph with defined flows, and CrewAI gives you a way to manage a team of role-playing AI agents solving a task. These are super useful, but they tend to be **self-contained ecosystems** — all the agents in that workflow are typically using the same framework or are tightly integrated through that framework’s logic.

**A2A is not another workflow engine or framework**. It doesn’t prescribe _how_ you design the logic of agent interactions or _which_ agents you use. Instead, **A2A focuses only on the communication layer**: it is a protocol that any agent (regardless of internal architecture) can use to talk to any other agent. In a way, you can imagine orchestration frameworks as different offices with their own internal processes, and A2A as the global phone/email system that connects all the offices. If you keep all your agents within one framework, you might not feel the need for A2A immediately — it’s like everyone in Office A already shares a language. But what if you want an agent from Office A to delegate a subtask to an agent from Office B? A2A steps in to make that possible without forcing both agents to migrate to the same framework. It **standardizes the “API” between agents across different ecosystems**.

The takeaway: **A2A isn’t here to replace those frameworks – it’s here to connect them**. You might still use LangGraph or CrewAI to handle the internal decision-making and prompt management of each agent, but use A2A as the messaging layer when agents need to reach out to others beyond their little silo. It’s like having a universal email protocol even if each person uses a different email client. Everyone can still communicate, regardless of the client.

## A Hands-On Example: The “Hello World” of Agent2Agent

No tech discussion would be complete without a “Hello, World!” example, right? Fortunately, the [A2A SDK](https://github.com/google-a2a/a2a-python) provides a delightfully simple **Hello World agent** to illustrate how this works. Let’s walk through a pared-down version of it to see A2A in action.

First, we need to define what our agent can do. In code, we define an **Agent Skill** and an **Agent Card** for our Hello World agent. The skill is the capability (in this case, basically just greeting the world), and the card is the agent’s public profile that advertises that skill. Here’s roughly what that looks like in Python:

```python
from a2a.types import AgentCard, AgentSkill, AgentCapabilities

# Define the agent's skill
skill = AgentSkill(
    id="hello_world",
    name="Returns hello world",
    description="Just returns hello world",
    tags=["hello world"],
    examples=["hi", "hello world"]
)

# Define the agent's "business card"
agent_card = AgentCard(
    name="Hello World Agent",
    description="Just a hello world agent",
    url="http://localhost:9999/",      # where this agent will be reachable
    version="1.0.0",
    defaultInputModes=["text"],        # it expects text input
    defaultOutputModes=["text"],       # it returns text output
    capabilities=AgentCapabilities(streaming=True),  # supports streaming responses
    skills=[skill]                     # list the skills it offers (just one here)
)
```

_Yes, even our Hello World agent has a resume!)_ In the code above, we created a skill with ID `"hello_world"` and a human-friendly name/description. We then made an AgentCard that says: “Hi, I’m **Hello World Agent**. You can reach me at `localhost:9999` and I know how to do one thing: `hello_world`.” This is basically the agent introducing itself and its abilities to the world. We also indicated that this agent communicates via plain text (no fancy images or JSON outputs here) and that it supports streaming (not that our simple skill needs it, but hey, it’s enabled).

Next, we need to give our agent some brains to actually handle the task. In a real scenario, this might involve connecting to an LLM or other logic. For Hello World, we can implement the handler in the most trivial way: whenever the agent receives a `hello_world` task, it will respond with, you guessed it, “Hello, world!” ![😀]. The A2A SDK uses an **Agent Executor** class where you plug in the logic for each skill. I won’t bore you with those details (it’s essentially one function that returns the string `"Hello World"` when invoked).

Finally, we spin up the agent as an A2A server. The SDK provides an `A2AStarletteApplication` (built on the Starlette web framework) to make our agent accessible via HTTP. We tie our AgentCard and Agent Executor into this app, then run it with Uvicorn (an async web server). In code, it’s something like:
```python
from a2a.server.apps import A2AStarletteApplication
from a2a.server.request_handlers import DefaultRequestHandler
from a2a.server.tasks import InMemoryTaskStore
import uvicorn

request_handler = DefaultRequestHandler(
        agent_executor=HelloWorldAgentExecutor(),
        task_store=InMemoryTaskStore(),
    )

server = A2AStarletteApplication(
    agent_card=agent_card,
    http_handler=request_handler
)

uvicorn.run(server.build(), host="0.0.0.0", port=9999)
```

When you run this, you now have a **live A2A agent** running at `http://localhost:9999`. It will serve its Agent Card at an endpoint (so any other agent can fetch `http://localhost:9999/.well-known/agent.json` to see who it is and what it can do), and it will listen for task requests at the appropriate endpoints (the SDK sets up routes like `/message/send` under the hood for JSON-RPC calls).

You can check out the full implementation in the [official A2A Python SDK on GitHub](https://github.com/google-a2a/a2a-samples/tree/main/samples/python/agents/helloworld).

---

To test it out, we could fire up a client (the SDK even provides a simple A2AClient class):

### Step 1: Install the A2A SDK using either `uv` or `pip`

Before you get started, make sure you have the following:

- **Python 3.10 or higher**
- **[uv](https://github.com/astral-sh/uv)** (optional but recommended for faster installs and clean dependency management) — or just stick with **pip** if you’re more comfortable with that
- An activated virtual environment

#### Option 1: Using `uv` (recommended)

If you’re working inside a `uv` project or virtual environment, this is the cleanest way to install dependencies:

```bash
uv add a2a-sdk
```

#### Option 2: Using `pip`

Prefer good ol’ pip? No problem — just run:

```bash
pip install a2a-sdk
```

Either way, this installs the official A2A SDK so you can start building and running agents right away.

### Step 2: Run the Remote Agent

First, clone the repo and start up the Hello World agent:

```bash
git clone https://github.com/google-a2a/a2a-samples.git
cd a2a-samples/samples/python/agents/helloworld
uv run .
```

This spins up a basic A2A-compatible agent ready to greet the world.
### Step 3: Run the Client (from another terminal)

Now, in a separate terminal, run the test client to send a message to your shiny new agent:

```bash
cd a2a-samples/samples/python/agents/helloworld
uv run test_client.py
```

Click here to see an example output

```bash
INFO:__main__:Attempting to fetch public agent card from: http://localhost:9999/.well-known/agent.json
INFO:httpx:HTTP Request: GET http://localhost:9999/.well-known/agent.json "HTTP/1.1 200 OK"
INFO:a2a.client.client:Successfully fetched agent card data from http://localhost:9999/.well-known/agent.json: {'capabilities': {'streaming': True}, 'defaultInputModes': ['text'], 'defaultOutputModes': ['text'], 'description': 'Just a hello world agent', 'name': 'Hello World Agent', 'skills': [{'description': 'just returns hello world', 'examples': ['hi', 'hello world'], 'id': 'hello_world', 'name': 'Returns hello world', 'tags': ['hello world']}], 'supportsAuthenticatedExtendedCard': True, 'url': 'http://localhost:9999/', 'version': '1.0.0'}
INFO:__main__:Successfully fetched public agent card:
INFO:__main__:{
  "capabilities": {
    "streaming": true
  },
  "defaultInputModes": [
    "text"
  ],
  "defaultOutputModes": [
    "text"
  ],
  "description": "Just a hello world agent",
  "name": "Hello World Agent",
  "skills": [
    {
      "description": "just returns hello world",
      "examples": [
        "hi",
        "hello world"
      ],
      "id": "hello_world",
      "name": "Returns hello world",
      "tags": [
        "hello world"
      ]
    }
  ],
  "supportsAuthenticatedExtendedCard": true,
  "url": "http://localhost:9999/",
  "version": "1.0.0"
}
INFO:__main__:
Using PUBLIC agent card for client initialization (default).
INFO:__main__:
Public card supports authenticated extended card. Attempting to fetch from: http://localhost:9999/agent/authenticatedExtendedCard
INFO:httpx:HTTP Request: GET http://localhost:9999/agent/authenticatedExtendedCard "HTTP/1.1 200 OK"
INFO:a2a.client.client:Successfully fetched agent card data from http://localhost:9999/agent/authenticatedExtendedCard: {'capabilities': {'streaming': True}, 'defaultInputModes': ['text'], 'defaultOutputModes': ['text'], 'description': 'The full-featured hello world agent for authenticated users.', 'name': 'Hello World Agent - Extended Edition', 'skills': [{'description': 'just returns hello world', 'examples': ['hi', 'hello world'], 'id': 'hello_world', 'name': 'Returns hello world', 'tags': ['hello world']}, {'description': 'A more enthusiastic greeting, only for authenticated users.', 'examples': ['super hi', 'give me a super hello'], 'id': 'super_hello_world', 'name': 'Returns a SUPER Hello World', 'tags': ['hello world', 'super', 'extended']}], 'supportsAuthenticatedExtendedCard': True, 'url': 'http://localhost:9999/', 'version': '1.0.1'}
INFO:__main__:Successfully fetched authenticated extended agent card:
INFO:__main__:{
  "capabilities": {
    "streaming": true
  },
  "defaultInputModes": [
    "text"
  ],
  "defaultOutputModes": [
    "text"
  ],
  "description": "The full-featured hello world agent for authenticated users.",
  "name": "Hello World Agent - Extended Edition",
  "skills": [
    {
      "description": "just returns hello world",
      "examples": [
        "hi",
        "hello world"
      ],
      "id": "hello_world",
      "name": "Returns hello world",
      "tags": [
        "hello world"
      ]
    },
    {
      "description": "A more enthusiastic greeting, only for authenticated users.",
      "examples": [
        "super hi",
        "give me a super hello"
      ],
      "id": "super_hello_world",
      "name": "Returns a SUPER Hello World",
      "tags": [
        "hello world",
        "super",
        "extended"
      ]
    }
  ],
  "supportsAuthenticatedExtendedCard": true,
  "url": "http://localhost:9999/",
  "version": "1.0.1"
}
INFO:__main__:
Using AUTHENTICATED EXTENDED agent card for client initialization.
INFO:__main__:A2AClient initialized.
INFO:httpx:HTTP Request: POST http://localhost:9999/ "HTTP/1.1 200 OK"
{'id': '66f96689-9442-4ead-abd1-69937fb682dc', 'jsonrpc': '2.0', 'result': {'kind': 'message', 'messageId': 'b2f37a5c-d535-4fbf-a43e-da1b64e04b22', 'parts': [{'kind': 'text', 'text': 'Hello World'}], 'role': 'agent'}}
INFO:httpx:HTTP Request: POST http://localhost:9999/ "HTTP/1.1 200 OK"
{'id': 'edaf70e3-909f-4d6d-9e82-849afae38756', 'jsonrpc': '2.0', 'result': {'kind': 'message', 'messageId': 'ee44ce5e-0cff-4247-9cfd-4778e764b75c', 'parts': [{'kind': 'text', 'text': 'Hello World'}], 'role': 'agent'}}
```

Once you run the client script, you’ll see a flurry of logs that walk you through the A2A handshake in action. The client first discovers the agent by fetching its **public Agent Card** from `http://localhost:9999/.well-known/agent.json`. This tells the client what the agent can do (in this case, respond to a friendly “hello”). But then something cooler happens: the agent also supports an **authenticated extended card**, so the client grabs that too from a special endpoint. Now it knows about _both_ the basic `hello_world` skill and the extra `super_hello_world` skill available to authenticated users. The client initializes itself using this richer version of the agent card, and sends a task asking the agent to say hello. The agent responds — twice in this run — with a structured A2A message containing `"Hello World"`, wrapped nicely in JSON. This roundtrip might seem simple, but it’s actually demonstrating the entire A2A lifecycle: **agent discovery, capability negotiation, message passing, and structured response**. It’s like two agents met, introduced themselves formally, agreed on what they could help with, and exchanged notes — all without you needing to write custom glue code.

---

This simple demo might not solve real problems, but it proves a critical point: with just a bit of setup, you can turn a piece of AI logic into an A2A-compatible agent that **any other A2A agent can discover and utilize**. Today it’s a hello world toy, tomorrow it could be a complex data-mining agent or an ML model specialist. The process would be analogous: define what it can do (skills), stand it up as a server with an AgentCard, and boom — it’s _plugged into the agent network_.

## Getting Started with A2A in Your Projects

Excited to make your AI agents actually talk to each other? Here are some practical pointers to get started:

1. **Install the A2A SDK:** Google has open-sourced an SDK (currently for Python, with others likely to follow). It’s as easy as a pip install: `pip install a2a-sdk`. This gives you the tools to define agents, run agent servers, and interact with them.
2. **Define Your Agents’ Skills and Cards:** Think about what each agent in your system should be able to do. Define an `AgentSkill` for each distinct capability (with a name, description, etc.), and create an `AgentCard` that lists those skills and relevant info about the agent (endpoint URL, supported data formats, etc.). The SDK’s documentation and examples (like the Hello World above) are great references for the syntax.
3. **Implement the Agent Logic:** This is where you connect the dots between the A2A protocol and your AI model or code. If your agent is essentially an LLM prompt, implement the executor to call your model with the prompt and return the result. If it’s doing something like a web search, write that code here. The A2A framework doesn’t limit what the agent _can do internally_ — it just defines how you expose it. For instance, you might use OpenAI’s API or a local model inside your executor, and that’s totally fine.
4. **Run the A2A Agent Server:** Using the SDK’s server utilities (as shown above with Starlette), run your agent so it starts listening for requests. Each agent will typically run on its own port or endpoint. Make sure it’s reachable (if you’re within a corporate network or cloud, you might deploy these as microservices).
5. **Connect Agents Together:** Now the fun part — have them talk! You can either write a client or use an existing orchestrator to send tasks between agents. The [A2A repo](https://github.com/google-a2a/a2a-samples) comes with sample clients and even a **multi-agent demo UI** that can coordinate messages between three agents (as a proof-of-concept). In practice, an agent can use the A2A SDK’s `A2AClient` to programmatically call another agent by its URL, or you can set up a simple relay (even cURL or Postman would do to hit the REST endpoint with a JSON payload). A2A handles the routing of the message to the right function on the remote agent and gives you back the response. It’s like calling a REST API, but the “service” on the other end is an intelligent agent rather than a fixed-function server.
6. **Explore Samples and Community Integrations:** A2A is new, but it’s gaining traction fast. The [official repository](https://github.com/google-a2a/A2A) provides **sample integrations for popular agent frameworks** — for example, how to wrap a LangChain/LangGraph agent with A2A, or how to expose a CrewAI agent via A2A. This means you don’t have to reinvent the wheel if you’re already using those tools; you can add an A2A interface to your existing agent with a bit of glue code. Also keep an eye on community projects — given that over 50 organizations are involved, we can expect many frameworks to offer native A2A support moving forward.
7. **Join the Conversation:** Since A2A is open-source and community-driven, you can get involved. There’s a [GitHub discussions forum](https://github.com/google-a2a/A2A/discussions) for A2A, and Google welcomes contributions and feedback. If you encounter issues or have ideas (maybe a feature for negotiating, say, image captions for visually impaired agents?), you can pitch in. The protocol spec is in draft and evolving, so who knows — your suggestion might become part of the standard!