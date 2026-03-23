select
    a.account_key,
    a.source_system,
    a.account_number,
    a.account_name,
    a.account_type,
    a.department_id,
    a.class_id,
    a.subsidiary_id,
    a.product_id,
    null as financial_statement,
    null as gaapmappingl1,
    null as gaapmappingl2,
    null as gaapmappingl3,
    null as gaapmappingl4,
    null as cashflowl1,
    null as cashflowl2,
    null as cashflowl3,
    null as pandlmultiplier,
    null as budgetmultiplier,
    null as debtmapping
from {{ source("cdm_finance", "dim_chart_of_accounts") }} a

left join {{ source("coa_mapping", "map_coa_reporting") }} b
    on a.account_id = b.account_id
    and upper(a.source_system) = upper(b.source_system)
    and current_date between b.effective_from and b.effective_to

where b.account_id is null
