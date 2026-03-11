{{ config(
    materialized='incremental',
    unique_key=['account_id','source_system','effective_from']
) }}

with mapped_accounts as (

    select
        account_id,
        source_system,
        account_number,
        account_name,
        account_type,
        department_id,
        class_id,
        subsidiary_id,
        product_id,
        financial_statement,
        gaapmappingl1,
        gaapmappingl2,
        gaapmappingl3,
        gaapmappingl4,
        cashflowl1,
        cashflowl2,
        cashflowl3,
        pandlmultiplier,
        budgetmultiplier,
        debtmapping
    from {{ source("coa_mapping","map_coa_reporting") }}

)


select * from mapped_accounts
