# hackerBooksPro
App para iOS que permite leer libros descargados de la red y hacer anotaciones en ellos.

Bugs conocidos:

- Es posible que la app se caiga en el primer arranque, creo que porque al comprobar si existen las tags o authors para crealos muta el NSSet
- No aparece el tag "favorites" en primer lugar
	- Usando un sortDescriptor que ordene por tag se llama al metodo -(NSComparisonResult)compare:(Tag *)otherObject;
		pero solo la primera vez
	- Si ordeno por tag.name no se llama al metodo anterior -compare
- Suele aparece algun error 1570 (CoreData dice que falta alguna propiedad no opcional) cuando hago favorito un libro (arreglado??)
- Creo nota y escribo algo, vuelvo a collection, vuelvo a libro, entro de nuevo a collection, a la nota creada, al volver de nuevo a la collection se cae la app
- La primera vez que arranco la app en iPad con un SplitView, trato de recuperar un libro desde la LibraryTableVC para rellenar la vista BookVC. No parece recuperar ninguno.
- El uso de una celda personalizada - BookTableViewCell-  para la tabla inicial-  LibraryTable - me da un error, en el que me dice que estoy cambiando autolayout desde segundo plano.
	- Seguramente es porque KVO se ejecuta en segundo plano al obtener el cambio en esa cola
- en cualquier mapa de notas me muestra la ultima nota, aunque no sea de ese libro.
