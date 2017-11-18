# CpShowPaysUnderSplitDetailFnd
Ex : 
loading CP00053 
num_po 4140727g01_2-2 
sku 05944 


SELECT
po.num_po, 
pos.ref as sku_num, 
pod.*
FROM pre_order as po
LEFT JOIN pre_order_skus as pos
ON po.id = pos.id_pre_order
LEFT JOIN pre_order_deliveries as pod
ON pos.id = pod.id_pre_order_sku
WHERE po.num_po ILIKE SPLIT_PART('4140727g01_2-2', '_', 1)
AND pos.ref ILIKE '05944'
