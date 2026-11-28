--5
SELECT COUNT(*) as customers_count
FROM customers;

/*Запрос COUNT выполняет подсчёт всех строк в таблице покупателей customers*/ 

--6.1
select e.first_name || ' ' || e.last_name as seller,
COUNT(s.*) as operations,
FLOOR(SUM(s.quantity * p.price)) as income
from employees e
join sales s on e.employee_id = s.sales_person_id
join products p on s.product_id = p.product_id
group by seller
order by income desc limit 10;
/*запрос выполняет подсчёт всех сделок и общую выручку каждого 
продавца с округлением до целого в меньшую сторону. выбраны 10 
лучших продавцов с наибольшей суммой выручки.*/

--6.2
with a as (
	select AVG(s.quantity * p.price) as avg_income
	from sales s 
	join products p on s.product_id = p.product_id
)

select e.first_name || ' ' || e.last_name as seller, 
FLOOR(AVG(s.quantity * p.price)) as average_income
from sales s 
join products p on s.product_id = p.product_id 
join employees e on s.sales_person_id = e.employee_id
group by seller
having AVG(s.quantity * p.price) < (
	select avg_income
	from a
)
order by average_income;
/*сте в начале высчитывает среднюю выручку среди всех сотрудников. 
в основном запросе высчитывается средняя выручка каждого 
сотрудника, а позже сравнивается с общей средней. выбраны те
сотрудники, чья средняя выручка ниже средней среди всех.*/

--6.3
with a as (
	select e.first_name || ' ' || e.last_name as seller,
	to_char(s.sale_date, 'FMDay') as day_of_week,
	FLOOR(SUM(s.quantity * p.price)) as income,
	extract(ISODOW from sale_date) as n_day
	from employees e 
	join sales s on e.employee_id = s.sales_person_id 
	join products p on s.product_id = p.product_id 
	group by seller, day_of_week, n_day
)

select seller, day_of_week, income
from a 
order by n_day, seller;
/*в сте находятся текстовый формат дней недели через TO_CHAR, 
выручка каждого сотрудника в отдельный день недели, а также 
порядковый номер каждого дня недели через EXTRACT. в основном 
запросе выводятся данные из сте и сортируются по номеру дня недели 
и имени сотрудника.*/
