#
rm(list=ls())
#
library(rvest)
#
webpage = read_html("https://www.geeksforgeeks.org/data-structures-in-r-programming")

### Ejemplo 1
# Using CSS selectors to scrape the heading section
heading = html_node(webpage, 'h1')

# Converting the heading data to text
text = html_text(heading)
print(text)

### Ejemplo 2
# Using CSS selectors to scrape
# all the paragraph section
# Note that we use html_nodes() here
paragraph = html_nodes(webpage, 'p')

# Converting the heading data to text
pText = html_text(paragraph)

# Print the top 6 data
print(head(pText))

# Ahora viene mi ejemplo:
fifa = read_html("https://es.wikipedia.org/wiki/Anexo:Grupo_A_de_la_Copa_Mundial_de_F%C3%BAtbol_de_2022")

equipo = html_elements(fifa, 'td > a')
text = html_text(equipo)
print(text)



fifa = read_html("https://es.wikipedia.org/wiki/Copa_Mundial_de_F%C3%BAtbol_de_2022")

lala <- fifa %>%
  html_elements('table') %>%
  html_table()

lele <- sapply(lala, dim)
lele[2,]==9

lolo <- lala[[26]]
