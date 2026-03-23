{{ config(
    materialized='incremental',
    unique_key=['account_id','source_system','effective_from']
) }}

with mapped_input as (

    select *
    from {{ ref('unmapped_coa_accounts') }}
    where gaap_mapping_l1 is not null

),

current_active as (

    {% if is_incremental() %}

    select *
    from {{ this }}
    where is_active = true

    {% else %}

    select * from mapped_input where 1=0

    {% endif %}

),

new_records as (

    select
        m.account_id,
        m.source_system,
        current_date as effective_from,
        '2999-12-31' as effective_to,
        true as is_active,
        m.gaap_mapping_l1,
        m.gaap_mapping_l2,
        m.gaap_mapping_l3,
        m.gaap_mapping_l4,
        m.cashflow_l1,
        m.cashflow_l2,
        m.cashflow_l3,
        m.pandl_multiplier,
        m.budget_multiplier,
        m.debt_mapping

    from mapped_input m

    left join current_active t
        on m.account_id = t.account_id
        and upper(m.source_system) = upper(t.source_system)

    where t.account_id is null

)

select * from new_records