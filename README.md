# hackerBooksPro
App para iOS que permite leer libros descargados de la red y hacer anotaciones en ellos.

Bugs conocidos:

- No se realiza la persistencia en CoreData.
	- No guardo libros
	- No guardo favoritos
	- No guardo notas
	- Creo nota y cancelo, al volver a la collection no ha desaparecido.
	- Creo nota y escribo algo, vuelvo a collection, vuelvo a libro, entro de nuevo a collection, a la nota creada, al volver de nuevo a la collection se cae la app
- La primera vez que arranco la app en iPad con un SplitView, trato de recuperar un libro desde la LibraryTableVC para rellenar la vista BookVC. No parece recuperar ninguno.
- El uso de una celda personalizada - BookTableViewCell-  para la tabla inicial-  LibraryTable - me da un error, en el que me dice que estoy cambiando autolayout desde segundo plano.
- Si hago una busqueda, entro al libro y
	- o vuelvo al Library y cancelo busqueda: no aparecen libros en la tabla
	- o marco como favorito y vuelvo al Library: no aparece la tag favoritos
en cualquier mapa de notas me muestra la ultima nota, aunque no sea de ese libro.
