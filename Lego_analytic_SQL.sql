--QUESTION 1: What is the total numbers of parts per theme
SELECT * FROM dbo.analytic_lego

SELECT theme_name, SUM(num_parts) as total_num_parts
FROM dbo.analytic_lego
--WHERE parent_theme_name is not null
GROUP BY theme_name
ORDER BY total_num_parts DESC

--QUESTION 2: What is the total parts per year
SELECT year, SUM(num_parts) as total_num_parts
FROM dbo.analytic_lego
GROUP BY year
ORDER BY total_num_parts DESC

--QUESTION 3: How many set create each century
SELECT Century, COUNT(set_num) as total_set
FROM dbo.analytic_lego
GROUP BY Century
ORDER BY total_set DESC

--QUESTION 4: Percentage of set in 21st Century is Star Wars Theme
SELECT  ROUND(CAST((SELECT COUNT(DISTINCT(set_num)) FROM dbo.analytic_lego 
		WHERE theme_name = 'Star Wars' AND Century = '21st Century') as FLOAT ) *100 / COUNT(set_num) , 2) as percentage
FROM dbo.analytic_lego


--QUESTION 5: WHat was the most popular theme in term of sets released in the 21st century
SELECT  year, theme_name, total_set
FROM(
	SELECT year, theme_name, COUNT(set_num) as total_set, ROW_NUMBER() OVER(partition by year order by count(set_num) DESC) as rn
	FROM dbo.analytic_lego
	GROUP BY year, theme_name
) as m
WHERE rn = 1
ORDER BY year DESC

--QUESTION 6: What is the most produced color of lego ever in terms of quantity of parts

SELECT c.name, SUM(CAST(inv.quantity as numeric ) ) as quantity
FROM inventory_parts inv JOIN colors c ON inv.color_id = c.id
GROUP BY c.name
ORDER BY quantity DESC