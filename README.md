erd-generator
=============

This is a basic entity relationship diagram (ERD) generator designed for data models that include the row key/column family/column qualifier structure (e.g. HBase, Accumulo). It generates a graphviz (.gv) file from .yaml/.yml files with Javascript, which can then be parsed using graphviz (dot and neato) into a png file.

Dependencies
-----------

Node Modules

* js-yaml
* DOMBuilder

Other Dependencies

* graphviz

YAML Description Format
----------------------

Each table is generated from a separate YAML file (.yaml or .yml), parsed based on the format described below. There are four root level elements: table, rowKey, columnFamilies, and connections. Each file must start with a `---` and end with a `...`.

**table**

The `table` element includes two subproperties: `label` and `description`. The `label` element is required, but the `description` element is optional and currently unimplemented. For a sample table which holds articles for a news outlet, the `table` property might look like this:

```
table:
	label: Article
	description: Information about the articles published by our news source	# Currently unimplemented
```

**rowKey**

The `rowKey` element includes one subproperty per piece of information that is contained in the element. This format includes three parts: the name (e.g. title), the type (e.g. string), and a description of the property (e.g. The title of the element). The name and type are required, but the description is optional. Each subproperty employs one of the following two formats, depending on whether the description is included or not:

```
name: type - description
name: type
```

The `rowKey` for an article for a news outlet might look like this:

```
rowKey:
	articleTitle: string - The title of the article
	articleAuthor: string - The author of the article
```

**columnFamilies**

The `columnFamilies` element holds the structure of the table itself and has subproperties which are the names of the column families that are contained in the table. Each column family in turn has a subproperty for each column qualifier which is contained within that column family. The column qualifier properties are structured in the same manner as the properties within `rowKey` described above with name, type and description (optional) portions.

A sample `columnFamilies` property from an article for a news outlet:

```
columnFamilies:
	Content:
		rawText: string - The raw text of the article
		htmlText: string - The html-formatted text of the article
	Metadata:
		author: string - The author of the article
		postTime: long - The UNIX timestamp for the post-time of the article
		lastUpdateTime: long - The UNIX timestamp for the time when the article was last updated
```

Column families with no column qualifiers are also acceptable, though unusual in practice.

**connections**

The `connections` element holds a set of properties which show the relationships between this table and other tables. Each connection to another table is specified by a subproperty which holds the name of the table to connect to and a description of the relationship between them. They follow the format:

```
tableName: quantifier -> quantifier
```

Each quantifier can hold one of three values, `many`, `one` or `none`. Anything else is assumed to be `none`, and no arrowhead is drawn. Going back to our article example, if we had another table holding multiple `Comment`s on each Article, there would a one to many relationship between the `Article` and `Comment` tables, and the following connections property in the `Article` table:

```
connections:
	Comment: one -> many
``` 

This poses a potential problem. If I identify the relationship from the opposite direction in my `Comment` table, would there be two relationships drawn? In short, no. The two are identified as duplicates, and only one arrow is drawn.

**Overall Article YAML File**

```
---
table:
        label: Article
        description: Information about the articles published by our news source        # Currently unimplemented

rowKey:
        articleTitle: string - The title of the article
        articleAuthor: string - The author of the article

columnFamilies:
        Content:
                rawText: string - The raw text of the article
                htmlText: string - The html-formatted text of the article
        Metadata:
                author: string - The author of the article
                postTime: long - The UNIX timestamp for the post-time of the article
                lastUpdateTime: long - The UNIX timestamp for the time when the article was last updated

connections:
        Comment: one -> many
...
``` 
