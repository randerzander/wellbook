use wellbook;

--select file_no, get_json_object(metadata, '$.c') as cib from log_metadata
select file_no, get_json_object(metadata, '$.curvealiases') as cib from log_metadata
where coalesce(
  get_json_object(metadata, '$.c.dept'),
  get_json_object(metadata, '$.c.depth'),
  get_json_object(metadata, '$.c.md')
) is null
;
