# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal Finance Manager MVP - A Streamlit application for importing, storing, viewing, and categorizing bank transactions. Built for weekly budget review meetings with support for ING bank CSVs and Dyme export files.

## Commands

**Run the application:**
```bash
python -m streamlit run app.py
```

**Install dependencies:**
```bash
pip install -r requirements.txt
```

## Architecture

This is a single-file MVP (`app.py`) with the following structure:

### Database Layer (SQLite - `finance.db`)
- **accounts**: Registry of known bank accounts (ING checking, savings, ABN AMRO)
- **categories**: Dyme taxonomy categories (super_category + category)
- **counterparty_map**: Learned mappings from counterparty names to categories for auto-categorization
- **transactions**: All imported transactions with category_id and is_internal_transfer flags

### CSV Parsers
Three formats are supported:
1. **Main ING account** - semicolon-separated, date format YYYYMMDD, European amount format (comma decimal)
2. **Savings ING account** - different column names ("Description" vs "Name / Description")
3. **Dyme export** - comma-separated, includes Super-category and Category columns for taxonomy seeding

### Key Design Patterns
- `@st.cache_resource` for database connection (singleton)
- `@st.cache_data` for query results
- Duplicate detection via UNIQUE constraint on (date, account, amount, name_description, notifications)
- Internal transfer detection: checks counterparty IBAN against KNOWN_ACCOUNTS dict, and scans for savings patterns ("spaarrekening", "oranje.*rekening", savings account numbers)
- Auto-categorization: fuzzy matches counterparty names against learned mappings from Dyme imports

### Known Accounts (hardcoded in KNOWN_ACCOUNTS dict)
- NL32INGB0709731663: ING Shared (joint)
- NL29INGB0008543937: ING Personal (Dave)
- NL24ABNA0249445328: ABN AMRO (Sahana)
- B96744071: ING Savings (joint, linked to shared checking)
- Z65878970: ING Savings (Dave, linked to personal checking)

### UI Pages
1. **Upload**: File uploader with format detection, preview, stats, and import with progress
2. **View Transactions**: Filterable table with date range, account, category, and transfer exclusion
3. **Accounts**: Display registered accounts and balances from transactions
4. **Spending**: Category breakdown with bar charts, monthly trends, and drill-down into transactions

## Data Flow

1. User uploads CSV(s) on Upload page
2. `parse_csv_file()` auto-detects format, delegates to appropriate parser
3. For Dyme files: `import_dyme_with_categories()` seeds categories/mappings, then inserts transactions
4. Post-import: `detect_and_mark_transfers()` and `categorize_transactions()` run automatically
5. View/Spending pages query transactions with category joins
