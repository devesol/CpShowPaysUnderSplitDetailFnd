SELECT
cl.idloading, 
clps.num_po, 
clps.sku_id, 
clpsdf.entrepot, 
clpsdf.estimed_date_arrived, 
clpsdf.idloading_po_sku, 
clpsdf.quantites, 
clpsdf.sous_pays, 
pdf.id as pdf_id,
pdf.ss_gpe as pdf_ss_gpe, 
pdf.statut_ss_gpe as pdf_statut_ss_gpe, 
ssg.id_sous_groupe, 
ssg.qty,
ssg.qty/pdf.quantites as ratio,  
ssg.qty/pdf.quantites*clpsdf.quantites as loading_ssg_qty,
rsg.cpc, 
rsg.groupe, 
rsg.name

FROM cp_loading as cl
LEFT JOIN cp_loading_po_sku as clps
ON cl.idloading = clps.idloading
LEFT JOIN cp_loading_po_sku_detail_fnd as clpsdf
ON clps.idloading_po_sku = clpsdf.idloading_po_sku
LEFT JOIN po_detail_fnd as pdf
ON clps.num_po = pdf.num_po
AND clps.sku_id = pdf.sku_id
AND clpsdf.entrepot = pdf.entrepot
--AND clpsdf.sous_pays = pdf.ss_gpe
AND clpsdf.sous_pays = pdf.statut_ss_gpe
LEFT JOIN split_sous_groupe as ssg
ON pdf.id = ssg.id_original
LEFT JOIN ref_sous_groupe as rsg
ON ssg.id_sous_groupe = rsg.id
WHERE 1=1
AND cl.ref ILIKE 'CP00003'
AND clps.num_po ILIKE '4140724G01%'
AND clps.sku_id ILIKE '14323'
ORDER BY 
cl.ref, 
clps.num_po, 
clps.sku_id
;
