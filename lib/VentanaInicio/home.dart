import 'package:flutter/material.dart';
import 'detalle_libro.dart';
import 'package:bookly12/vistaPerfil/vistaPerfil.dart';
import 'package:bookly12/Ventana-Presentar/publicar_libro.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> libros = [];
  bool isLoading = true;
  String errorMessage = '';
  StreamSubscription<DatabaseEvent>? _booksSubscription;

  // Constantes optimizadas
  static const String _databaseUrl = 'https://bookly-6db9d-default-rtdb.firebaseio.com/';
  static const Color _backgroundColor = Color(0xFFE1E3DD);
  
  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    _booksSubscription?.cancel();
    super.dispose();
  }

  // Función helper mejorada para obtener valores
  String _getValueSafely(Map? data, List<String> keys, String defaultValue) {
    if (data == null) return defaultValue;
    
    for (String key in keys) {
      final value = data[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return defaultValue;
  }

  // NUEVA FUNCIÓN: Validar si una URL de imagen es válida
  bool _isValidImageUrl(String url) {
    if (url.isEmpty) return false;
    
    // Lista de extensiones de imagen válidas
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    final lowerUrl = url.toLowerCase();
    
    // Verificar si tiene una extensión válida
    bool hasValidExtension = validExtensions.any((ext) => lowerUrl.contains(ext));
    
    // Verificar si es una URL válida
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https') && hasValidExtension;
    } catch (e) {
      return false;
    }
  }

  // NUEVA FUNCIÓN: Limpiar y normalizar URL
  String _cleanImageUrl(String url) {
    if (url.isEmpty) return '';
    
    String cleanUrl = url.trim();
    
    // Remover parámetros problemáticos que pueden causar errores de decodificación
    if (cleanUrl.contains('?')) {
      cleanUrl = cleanUrl.split('?')[0];
    }
    
    // Asegurar protocolo HTTPS
    if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
      cleanUrl = 'https://$cleanUrl';
    }
    
    return cleanUrl;
  }

  // NUEVA FUNCIÓN: Probar si la URL de imagen es accesible
  Future<bool> _testImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url)).timeout(
        const Duration(seconds: 5),
      );
      
      // Verificar que la respuesta sea exitosa y que sea una imagen
      return response.statusCode == 200 && 
             (response.headers['content-type']?.startsWith('image/') ?? false);
    } catch (e) {
      print('Error probando URL: $url - $e');
      return false;
    }
  }

  void _loadBooks() {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    _booksSubscription?.cancel();
    
    try {
      final database = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: _databaseUrl
      ).ref();
      
      _booksSubscription = database.child('users').onValue.listen(
        (event) {
          _processBookData(event.snapshot.value);
        },
        onError: (error) {
          _handleError('Error de conexión: $error');
        },
      );
    } catch (e) {
      _handleError('Error al conectar con la base de datos: $e');
    }
  }

  void _processBookData(dynamic data) {
    List<Map<String, dynamic>> books = [];
    
    if (data is Map) {
      data.forEach((userId, userData) {
        if (userData is Map && userData['libros'] is Map) {
          final userBooks = userData['libros'] as Map;
          userBooks.forEach((libroKey, libroData) {
            if (libroData is Map) {
              final bookMap = _createBookMap(libroData, userId.toString(), libroKey.toString());
              // Solo agregar libros que tengan al menos título o imagen
              if (bookMap['title'] != 'Sin título' || bookMap['imagePath'].isNotEmpty) {
                books.add(bookMap);
              }
            }
          });
        }
      });
    }
    
    // Ordenar libros por fecha de creación (si existe) o por título
    books.sort((a, b) {
      // Si tienes fecha de creación, úsala
      if (a['fechaCreacion'] != null && b['fechaCreacion'] != null) {
        return b['fechaCreacion'].compareTo(a['fechaCreacion']);
      }
      // Si no, ordenar por título
      return a['title'].compareTo(b['title']);
    });
    
    if (mounted) {
      setState(() {
        libros = books;
        isLoading = false;
        errorMessage = '';
      });
    }
  }

  void _handleError(String error) {
    if (mounted) {
      setState(() {
        errorMessage = error;
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> _createBookMap(Map libroData, String userId, String libroKey) {
    return {
      'title': _getValueSafely(libroData, ['Título', 'title', 'titulo'], 'Sin título'),
      'author': _getValueSafely(libroData, ['Autor', 'author', 'autor'], 'Autor desconocido'),
      'year': _getValueSafely(libroData, ['Año', 'year', 'anio'], 'Año desconocido'),
      'user': userId,
      'imagePath': _getValueSafely(libroData, ['Imagen', 'imagePath', 'imageUrl', 'imagen'], ''),
      'libroId': libroKey,
      'userId': userId,
      'fechaCreacion': libroData['fechaCreacion'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('BOOKLY'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBooks,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/banner.jpeg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavButton(
            icon: Icons.add_circle_outline,
            label: 'Agregar',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LibrosForm()),
            ),
          ),
          _buildNavButton(
            icon: Icons.person_outline,
            label: 'Perfil',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => vistaPerfil()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 28),
          onPressed: onPressed,
          tooltip: label,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (errorMessage.isNotEmpty) return _buildErrorState();
    if (isLoading) return _buildLoadingState();
    if (libros.isEmpty) return _buildEmptyState();
    
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildBookCard(libros[index]),
        childCount: libros.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.48,
      ),
    );
  }

  Widget _buildLoadingState() {
    return const SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando libros...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage,
                style: const TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadBooks,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No hay libros publicados aún',
              style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sé el primero en compartir un libro',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LibrosForm()),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Agregar primer libro'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleLibro(
              titulo: book['title'] ?? 'Sin título',
              autor: book['author'] ?? 'Autor desconocido',
              anio: book['year'] ?? 'Año desconocido',
              usuario: book['user'] ?? 'Usuario desconocido',
              imagen: book['imagePath'] ?? '',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildBookImage(book['imagePath'] ?? ''),
        ),
      ),
    );
  }

  // FUNCIÓN MEJORADA: Nueva implementación para cargar imágenes sin errores
  Widget _buildBookImage(String imagePath) {
    if (imagePath.isEmpty || !_isValidImageUrl(imagePath)) {
      return _buildPlaceholder('Sin imagen válida');
    }

    String cleanUrl = _cleanImageUrl(imagePath);
    
    return FutureBuilder<bool>(
      future: _testImageUrl(cleanUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingPlaceholder();
        }
        
        if (snapshot.hasData && snapshot.data == true) {
          return _buildRobustImage(cleanUrl);
        } else {
          return _buildPlaceholder('Imagen no disponible');
        }
      },
    );
  }

  // NUEVA FUNCIÓN: Widget robusto para cargar imágenes con múltiples fallbacks
  Widget _buildRobustImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      
      // Headers mejorados para mejor compatibilidad
      httpHeaders: const {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
        'Accept-Encoding': 'gzip, deflate, br',
        'Cache-Control': 'no-cache',
      },
      
      placeholder: (context, url) => _buildLoadingPlaceholder(),
      
      errorWidget: (context, url, error) {
        print('CachedNetworkImage falló: $url - Error: $error');
        
        // Fallback a Image.network
        return _buildFallbackImage(url);
      },
      
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
      
      // Configuración de memoria más conservadora para evitar errores
      memCacheWidth: 300,
      memCacheHeight: 400,
      maxWidthDiskCache: 300,
      maxHeightDiskCache: 400,
      filterQuality: FilterQuality.low, // Cambiar a low para evitar problemas de decodificación
    );
  }

  // NUEVA FUNCIÓN: Fallback con Image.network
  Widget _buildFallbackImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        print('Image.network también falló para: $url - Error: $error');
        return _buildPlaceholder('Error al cargar imagen');
      },
      headers: const {
        'User-Agent': 'Mozilla/5.0 (compatible; BooklyApp/1.0)',
        'Accept': 'image/*',
      },
    );
  }

  // NUEVA FUNCIÓN: Placeholder de carga mejorado
  Widget _buildLoadingPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Cargando imagen...',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String message) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 40, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}