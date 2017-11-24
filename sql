--INSERT INTO split_sous_groupe (id_floating, id_sous_groupe, qty )

SELECT
clpsdf.id as id_floating,
pdf.id_sous_groupe,
ROUND(pdf.ratio*clpsdf.quantites) as qty,

/*WHERE 0 = (
SELECT COUNT(*)
FROM
)
*/
cl.ref,
cl.idloading,
clps.num_po,
clps.sku_id,
clpsdf.id as clpsdf_id,
clpsdf.entrepot,
clpsdf.estimed_date_arrived,
clpsdf.idloading_po_sku,
clpsdf.quantites,
clpsdf.sous_pays,
pdf.pdf_ss_gpe as pdf_ss_gpe,
pdf.pdf_statut_ss_gpe as pdf_statut_ss_gpe,
pdf.entrepot as pdf_entrepot,
pdf.pdf_qty as pdf_qty,
pdf.ssg_qty,
pdf.ratio,
ROUND(pdf.ratio*clpsdf.quantites) as loading_ssg_qty,
pdf.id_sous_groupe,
pdf.rsg_cpc,
pdf.rsg_group,
pdf.rsg_name

FROM cp_loading as cl
LEFT JOIN cp_loading_po_sku as clps
ON cl.idloading = clps.idloading
LEFT JOIN cp_loading_po_sku_detail_fnd as clpsdf
ON clps.idloading_po_sku = clpsdf.idloading_po_sku
LEFT JOIN (
	SELECT
	SPLIT_PART(pdf.num_po, '_', 1) as num_po,
	pdf.sku_id,
	pdf.entrepot as entrepot,
	pdf.ss_gpe as pdf_ss_gpe,
	pdf.statut_ss_gpe as pdf_statut_ss_gpe,
	rsg.cpc as rsg_cpc,
	rsg.groupe as rsg_group,
	rsg.name as rsg_name,
    ssg.id_sous_groupe,
	SUM(pdf.quantites) as pdf_qty,
	SUM(ssg.qty) as ssg_qty,
    (SUM(CAST(ssg.qty AS NUMERIC))/SUM(pdf.quantites) ) as ratio
	FROM po_detail_fnd as pdf

	LEFT JOIN split_sous_groupe as ssg
	ON pdf.id =   ssg.id_original
	LEFT JOIN ref_sous_groupe as rsg
	ON ssg.id_sous_groupe = rsg.id
    WHERE 1=1
    AND pdf.num_po ILIKE '4140724G01%'
	AND pdf.sku_id ILIKE '14323'
	AND pdf.entrepot ILIKE 'log line%'
	GROUP BY
	SPLIT_PART(pdf.num_po, '_', 1),
	pdf.sku_id,
	pdf.ss_gpe,
	pdf.statut_ss_gpe,
	pdf.entrepot,
    ssg.id_sous_groupe,
	rsg.cpc,
	rsg.groupe,
	rsg.name
    ORDER BY
	SPLIT_PART(pdf.num_po, '_', 1),
    pdf.sku_id,
	pdf.entrepot,
    pdf.ss_gpe,
    pdf.statut_ss_gpe,
    rsg.cpc,
    rsg.groupe,
    rsg.name

) as pdf
ON TRIM(SPLIT_PART(clps.num_po, '_', 1)) = TRIM(pdf.num_po)
AND TRIM(clps.sku_id) = TRIM(pdf.sku_id)
AND TRIM(clpsdf.entrepot) = TRIM(pdf.entrepot)
WHERE 1=1
--AND cl.ref ILIKE 'CP00003'
AND SPLIT_PART(clps.num_po, '_', 1) ILIKE SPLIT_PART('4140724G01_1-3', '_', 1)
AND clps.sku_id ILIKE '14323'
AND clpsdf.entrepot ILIKE 'log line%'
AND clpsdf.quantites > 0
ORDER BY
cl.ref,
clps.num_po,
clps.sku_id
;
