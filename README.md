# CortexDB

**The New Brain: Local-first Database Engine for CortexSync Ecosystem**

> [!WARNING]
> **🚧 Alpha Version (Under Active Development)**
> This project is currently in early alpha stage and is undergoing heavy development. Features, APIs, and CLI commands are subject to breaking changes without notice. 
> 
> **Current Testing Environment (As of 25 Feb 2026):**
> Testing is exclusively performed on a developer machine running **macOS Sequoia 15.7.4** with the latest versions of compatible IDEs (Cursor/VS Code/Windsurf). 
> 
> *If you are cloning this repository to run on Windows, Linux, or older IDE versions, you may encounter instability or broken features. Cross-platform testing will be expanded in future releases.*

## 🌟 Overview
CortexDB is the dedicated database engine for the Cortex-Works ecosystem, managing Scrum logic (Epics, Tickets, Backlog) and Agent Memory. Designed specifically to transition away from flat JSONL ledgers to relational and vector storage, allowing for scalable, enterprise-grade AI agent tracking.

### 🏛️ The "Data Triad" Architecture
CortexDB plays a central role in the Data Triad Architecture:

1. **CortexSync:** The Pulsar / Event Router (Watchers and notification endpoints).
2. **CortexDB (This Repo):** The New Brain. Manages state and database integration.
    - **SQLite (Local):** Stores relational data like Epic/Ticket tracking, assignments, and structural relationships.
    - **LanceDB (Local):** Lightweight vector database for semantic search and Retrieval-Augmented Generation (RAG).
3. **CortexRelay:** The Sync & Backup Engine.

### 💡 Why CortexDB?
* **Performance:** Blazing fast SQLite for querying and LanceDB for vector search in milliseconds.
* **Scale:** Seamlessly supports UI integration for Kanban boards, burn-down charts, and sprint backlogs in `cortex-studio`.
* **Separation of Concerns:** DB logic is decoupled from watcher threads in `cortex-sync`, avoiding "God Object" congestion and conflict.

## 🚀 Phase 3 & 4 Roadmap
This repository powers **Phase 3** of the Cortex-Works Ecosystem roadmap:
* **Migration from JSONL to Local-First DBs:** Decouple the Data Layer from the Sync Engine.
* **SQLite Integration:** Store relational data to prepare for the workflow structure system (Epic, Ticket, Agent Assignment).
* **Embedded LanceDB:** Isolate Vector Storage for millisecond semantic search (Zero-config).
