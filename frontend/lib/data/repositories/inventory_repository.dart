import '../../models/item_model.dart';
import '../datasources/local_inventory_datasource.dart';
import '../../api/api.dart';

class InventoryRepository {
  final LocalInventoryDataSource _dataSource;

  InventoryRepository(this._dataSource);

  // Helper mapping function to parse JSON database items to the frontend Item model
  Item _mapJsonToItem(Map<String, dynamic> json) {
    final int id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0;
    final String name = json['name'] ?? '';

    // Correctly parse price (handling integers, doubles, and string values from DB)
    int dbPrice = 0;
    if (json['price'] != null) {
      if (json['price'] is int) {
        dbPrice = json['price'] as int;
      } else if (json['price'] is double) {
        dbPrice = (json['price'] as double).toInt();
      } else {
        dbPrice = double.tryParse(json['price'].toString())?.toInt() ?? 0;
      }
    }

    // Correctly parse stock
    int dbStock = 0;
    if (json['stock'] != null) {
      if (json['stock'] is int) {
        dbStock = json['stock'] as int;
      } else if (json['stock'] is double) {
        dbStock = (json['stock'] as double).toInt();
      } else {
        dbStock = double.tryParse(json['stock'].toString())?.toInt() ?? 0;
      }
    }

    final String dbType = json['type'] ?? 'resource';
    final String dbDesc = json['description'] ?? '';
    final String? dbImage = json['image'];

    // Restore original properties from LocalInventoryDataSource if a match is found
    // Match by ID or by name (case-insensitive)
    final localItem = _dataSource.items.firstWhere(
      (item) => item.id == id || item.name.toLowerCase() == name.toLowerCase(),
      orElse: () => null as dynamic,
    );

    // Merge logic: use local item's original values as primary if the DB contains mock placeholders
    final String finalDesc = (localItem != null && (dbDesc.isEmpty || dbDesc == 'Legendary Light Cone' || dbDesc == 'Powerful Light Cone' || dbDesc == 'Premium currency' || dbDesc.startsWith('An advanced combat') || dbDesc.startsWith('A covertly encrypted') || dbDesc.startsWith('A combat-oriented') || dbDesc.startsWith('A relentless pursuit') || dbDesc.startsWith('A Light Cone developed') || dbDesc.startsWith('A stealth-oriented') || dbDesc.startsWith('A sniper-class') || dbDesc.startsWith('A Light Cone balancing') || dbDesc.startsWith('A rapid-strike') || dbDesc.startsWith('A Light Cone that enhances') || dbDesc.startsWith('A graceful Light Cone') || dbDesc.startsWith('An elite Light Cone') || dbDesc.startsWith('A legendary Light Cone') || dbDesc.startsWith('A memory-focused') || dbDesc.startsWith('A Light Cone whose') || dbDesc.startsWith('A Light Cone specializing') || dbDesc.startsWith('A practical Light Cone') || dbDesc.startsWith('A tactical Light Cone') || dbDesc.startsWith('A command Light Cone') || dbDesc.startsWith('A reflective Light Cone') || dbDesc.startsWith('A rhythm-based') || dbDesc.startsWith('A melancholic') || dbDesc.startsWith('A diplomatic') || dbDesc.startsWith('A ceremonial') || dbDesc.startsWith('A mechanical') || dbDesc.startsWith('A Nihility') || dbDesc.startsWith('A Kafka signature') || dbDesc.startsWith('Universal currency') || dbDesc.startsWith('Rare crystalline') || dbDesc.startsWith('Premium exchange') || dbDesc.startsWith('Residual energy') || dbDesc.startsWith('Token from') || dbDesc.startsWith('Dream-derived') || dbDesc.startsWith('Beginner expedition') || dbDesc.startsWith('Combat experience') || dbDesc.startsWith('Advanced training') || dbDesc.startsWith('Basic energy') || dbDesc.startsWith('Refined energy') || dbDesc.startsWith('High purity') || dbDesc.startsWith('Ascension material') || dbDesc.startsWith('Combat ascension') || dbDesc.startsWith('Elite pursuit') || dbDesc.startsWith('Basic cognitive') || dbDesc.startsWith('Advanced cognitive') || dbDesc.startsWith('Elite cognitive') || dbDesc.startsWith('Dark crystallized') || dbDesc.startsWith('Refined destructive') || dbDesc.startsWith('Advanced emotional') || dbDesc.startsWith('Basic support') || dbDesc.startsWith('Ancient support') || dbDesc.startsWith('High-level harmony') || dbDesc.startsWith('Basic combat') || dbDesc.startsWith('Defensive stabilization') || dbDesc.startsWith('Regenerative synchronization') || dbDesc.startsWith('Advanced healing') || dbDesc.startsWith('Immortal regenerative') || dbDesc.startsWith('Broken relic') || dbDesc.startsWith('Corrupted simulation') || dbDesc.startsWith('Cyber combat') || dbDesc.startsWith('Long-range travel') || dbDesc.startsWith('Logistics supply') || dbDesc.startsWith('Core code') || dbDesc.startsWith('Damaged propulsion') || dbDesc.startsWith('Increase max') || dbDesc.startsWith('Emotional memory') || dbDesc.startsWith('Unstable modified') || dbDesc.startsWith('Quantum combat'))) 
        ? localItem.desc 
        : (dbDesc.isNotEmpty ? dbDesc : (localItem != null ? localItem.desc : ''));

    final int finalPrice = (localItem != null && (dbPrice == 920 || dbPrice == 880 || dbPrice == 180 || dbPrice == 980 || dbPrice == 520 || dbPrice == 450 || dbPrice == 510 || dbPrice == 890 || dbPrice == 970 || dbPrice == 860 || dbPrice == 780 || dbPrice == 430 || dbPrice == 440 || dbPrice == 400 || dbPrice == 1000 || dbPrice == 730 || dbPrice == 540 || dbPrice == 390 || dbPrice == 610 || dbPrice == 930 || dbPrice == 480 || dbPrice == 470 || dbPrice == 680 || dbPrice == 220 || dbPrice == 960 || dbPrice == 1100 || dbPrice == 570 || dbPrice == 620 || dbPrice == 12 || dbPrice == 130 || dbPrice == 72 || dbPrice == 260 || dbPrice == 240 || dbPrice == 28 || dbPrice == 96 || dbPrice == 24 || dbPrice == 48 || dbPrice == 94 || dbPrice == 56 || dbPrice == 84 || dbPrice == 122 || dbPrice == 34 || dbPrice == 64 || dbPrice == 108 || dbPrice == 104 || dbPrice == 148 || dbPrice == 42 || dbPrice == 76 || dbPrice == 134 || dbPrice == 86 || dbPrice == 118 || dbPrice == 188 || dbPrice == 92 || dbPrice == 126 || dbPrice == 144 || dbPrice == 110 || dbPrice == 74 || dbPrice == 164 || dbPrice == 172 || dbPrice == 210 || dbPrice == 138 || dbPrice == 198 || dbPrice == 176)) 
        ? localItem.price 
        : dbPrice;

    final String finalEmoji = localItem != null ? localItem.emoji : (dbType.toLowerCase() == 'lightcone' ? '🌌' : '💳');
    
    // If the image is empty or a relative asset path, fallback to local path if available
    final String finalImagePath = (dbImage == null || dbImage.isEmpty || dbImage.startsWith('assets/images/')) 
        ? (localItem != null ? localItem.imagePath ?? '' : dbImage ?? '') 
        : dbImage;

    final String finalCategory = localItem != null ? localItem.category : (dbType.toLowerCase() == 'lightcone' ? 'LIGHT CONE' : 'RESOURCE');
    final String finalLabel = localItem != null ? localItem.label : (dbType.toLowerCase() == 'lightcone' ? 'LC' : 'RES');
    final String finalRarity = localItem != null ? localItem.rarity : (finalPrice >= 800 ? '5-star' : '4-star');

    // Map Event tags based on item name/desc to sync with the event carousel
    String? eventTag = localItem?.eventTag;
    if (eventTag == null) {
      if (name.toLowerCase().contains('firefly') || finalDesc.toLowerCase().contains('firefly') || name.toLowerCase().contains('sam') || finalDesc.toLowerCase().contains('sam') || (finalImagePath.toLowerCase().contains('sam'))) {
        eventTag = 'firefly';
      } else if (name.toLowerCase().contains('kafka') || finalDesc.toLowerCase().contains('kafka') || (finalImagePath.toLowerCase().contains('kafka'))) {
        eventTag = 'kafka';
      } else if (name.toLowerCase().contains('jingliu') || finalDesc.toLowerCase().contains('jingliu') || (finalImagePath.toLowerCase().contains('jingliu'))) {
        eventTag = 'jingliu';
      } else if (name.toLowerCase().contains('aventurine') || finalDesc.toLowerCase().contains('aventurine') || (finalImagePath.toLowerCase().contains('aventurine'))) {
        eventTag = 'aventurine';
      }
    }

    return Item(
      id: id,
      name: name,
      type: dbType,
      label: finalLabel,
      desc: finalDesc,
      stock: dbStock,
      price: finalPrice,
      emoji: finalEmoji,
      imagePath: finalImagePath,
      rarity: finalRarity,
      category: finalCategory,
      eventTag: eventTag,
    );
  }

  // =========================================================
  // ALL ITEMS
  // =========================================================

  Future<List<Item>> getItems() async {
    try {
      final res = await Api.getItems();
      if (res is List) {
        return res.map((item) => _mapJsonToItem(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      print("Error fetching items from API: $e");
    }
    // Fallback to local
    return List.from(_dataSource.items);
  }

  // =========================================================
  // MAIN SHOP ITEMS
  // =========================================================

  Future<List<Item>> getMainItems() async {
    try {
      final res = await Api.getItems();
      if (res is List) {
        return res
            .map((item) => _mapJsonToItem(item as Map<String, dynamic>))
            .where((item) => item.eventTag == null)
            .toList();
      }
    } catch (e) {
      print("Error fetching main items: $e");
    }
    // Fallback to local
    return _dataSource.items.where((item) => item.eventTag == null).toList();
  }

  // =========================================================
  // EVENT ITEMS
  // =========================================================

  Future<List<Item>> getEventItems(String eventTag) async {
    try {
      final res = await Api.getItems();
      if (res is List) {
        return res
            .map((item) => _mapJsonToItem(item as Map<String, dynamic>))
            .where((item) => item.eventTag == eventTag)
            .toList();
      }
    } catch (e) {
      print("Error fetching event items: $e");
    }
    // Fallback to local
    return _dataSource.items.where((item) => item.eventTag == eventTag).toList();
  }

  // =========================================================
  // ADD ITEM
  // =========================================================

  Future<void> addItem(Item item) async {
    try {
      await Api.createItem({
        "name": item.name,
        "type": item.type,
        "description": item.desc,
        "stock": item.stock,
        "price": item.price,
        "image": item.imagePath ?? "",
      });
    } catch (e) {
      print("Error adding item via API: $e");
      _dataSource.items.add(item); // Fallback
    }
  }

  // =========================================================
  // UPDATE ITEM
  // =========================================================

  Future<void> updateItem(Item updatedItem) async {
    try {
      await Api.updateItem(updatedItem.id, {
        "name": updatedItem.name,
        "type": updatedItem.type,
        "description": updatedItem.desc,
        "stock": updatedItem.stock,
        "price": updatedItem.price,
        "image": updatedItem.imagePath ?? "",
      });
    } catch (e) {
      print("Error updating item via API: $e");
      int index = _dataSource.items.indexWhere((i) => i.id == updatedItem.id);
      if (index != -1) {
        _dataSource.items[index] = updatedItem;
      }
    }
  }

  // =========================================================
  // DELETE ITEM
  // =========================================================

  Future<void> deleteItem(int id) async {
    try {
      await Api.deleteItem(id);
    } catch (e) {
      print("Error deleting item via API: $e");
      _dataSource.items.removeWhere((i) => i.id == id);
    }
  }

  // =========================================================
  // REDUCE STOCK
  // =========================================================

  Future<void> reduceStock(int itemId, int quantity) async {
    try {
      final items = await getItems();
      final item = items.firstWhere((i) => i.id == itemId);
      int newStock = item.stock - quantity;
      if (newStock < 0) newStock = 0;
      await Api.updateItem(itemId, {
        "name": item.name,
        "type": item.type,
        "description": item.desc,
        "stock": newStock,
        "price": item.price,
        "image": item.imagePath ?? "",
      });
    } catch (e) {
      print("Error reducing stock via API: $e");
      int index = _dataSource.items.indexWhere((i) => i.id == itemId);
      if (index != -1) {
        _dataSource.items[index].stock -= quantity;
        if (_dataSource.items[index].stock < 0) {
          _dataSource.items[index].stock = 0;
        }
      }
    }
  }
}
