select * from ma_asos.ma_price_change where status = 'W';

				
select * from rpm_price_change where (item,location,EFFECTIVE_DATE)
    in (select item,location,EFFECTIVE_DATE from ma_asos.ma_price_change where status = 'W')
    and state != 'pricechange.state.worksheet';
    

delete from ma_asos.ma_price_change  where status = 'W' and (item,location,EFFECTIVE_DATE)
    in (select item,location,EFFECTIVE_DATE from rpm_price_change where state != 'pricechange.state.worksheet');

select * from period;
