{%- if pillar.dcgm_exporter is defined and pillar.get('dcgm_exporter', {}).get('enabled', False) %}

include:
  - .install

{%- endif %}
