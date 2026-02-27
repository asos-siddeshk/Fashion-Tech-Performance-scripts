select * from rms.tsfhead where tsf_no = '8459925595';
select * from rms.shipsku where distro_no = '8459925595';

select BOL_NO as Consignment, sh.SHIP_DATE+10 as DateClosedUtc , w.WH_NAME_SECONDARY as ReceivingWarehouseId from shipment sh,wh w 
    where sh.to_loc  ='4' and sh.to_loc =w.wh and sh.order_no is null and sh.status_code ='R' and rownum <= '100' order by w.WH_NAME_SECONDARY;

select distinct CARTON as BOX_ID from rms.shipsku where shipment  in (select shipment from rms.shipment where BOL_NO ='7010625243');
    
 BAM-DTHUB-RIWTSV-099c   
    
    
    
   
<IWTConsignmentClosure xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="IWT Consignment Closure.xsd">
	<ConsignmentClosure>
		<ReceivingWarehouseId>FC01</ReceivingWarehouseId>
		<DateClosedUtc>2018-06-28T08:42:03+01:00</DateClosedUtc>
		<Consignments>
			<Consignment id="IWTC1529932797311">
				<Missing>
					<Box id="9800197559" />
				</Missing>
			</Consignment>
		</Consignments>
	</ConsignmentClosure>
</IWTConsignmentClosure>
