// ============================================================================
// SEARCH BAR IMPLEMENTATION FOR APPSPAGE
// ============================================================================
// 
// This file contains the complete implementation for adding a functional
// Material 3 SearchBar to the AppsPage with integrated filtering logic.
//
// INTEGRATION STEPS:
// 1. Add a TextEditingController to AppsPageState
// 2. Add the search bar widget to the CustomScrollView slivers
// 3. Update the filtering logic to include search text filtering
// 4. Dispose of the controller in the State's dispose method
//
// ============================================================================

// STEP 1: Add these fields to the AppsPageState class
// ============================================================================
/*
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
*/

// STEP 2: Add this widget to the CustomScrollView slivers (after CustomAppBar)
// ============================================================================
/*
  SliverToBoxAdapter(
    child: _buildSearchBar(context),
  ),
*/

// STEP 3: Add this method to AppsPageState
// ============================================================================
/*
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: SearchBar(
        controller: _searchController,
        hintText: tr('search'),
        hintStyle: WidgetStatePropertyAll(
          Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        textStyle: WidgetStatePropertyAll(
          Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        elevation: const WidgetStatePropertyAll(0),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: _searchQuery.isNotEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ]
            : [],
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }
*/

// STEP 4: Update the filtering logic in the build method
// ============================================================================
// Replace the existing filtering section (around line 250-280) with:
/*
    listedApps = listedApps.where((app) {
      // Existing filters
      if (app.app.installedVersion == app.app.latestVersion &&
          !(filter.includeUptodate)) {
        return false;
      }
      if (app.app.installedVersion == null && !(filter.includeNonInstalled)) {
        return false;
      }
      
      // Search query filter (NEW)
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = app.name.toLowerCase().contains(query);
        final matchesAuthor = app.author.toLowerCase().contains(query);
        final matchesId = app.app.id.toLowerCase().contains(query);
        
        if (!matchesName && !matchesAuthor && !matchesId) {
          return false;
        }
      }
      
      // Existing name and author filters
      if (filter.nameFilter.isNotEmpty || filter.authorFilter.isNotEmpty) {
        List<String> nameTokens = filter.nameFilter
            .split(' ')
            .where((element) => element.trim().isNotEmpty)
            .toList();
        List<String> authorTokens = filter.authorFilter
            .split(' ')
            .where((element) => element.trim().isNotEmpty)
            .toList();

        for (var t in nameTokens) {
          if (!app.name.toLowerCase().contains(t.toLowerCase())) {
            return false;
          }
        }
        for (var t in authorTokens) {
          if (!app.author.toLowerCase().contains(t.toLowerCase())) {
            return false;
          }
        }
      }
      
      // Rest of existing filters...
      if (filter.idFilter.isNotEmpty) {
        if (!app.app.id.contains(filter.idFilter)) {
          return false;
        }
      }
      if (filter.categoryFilter.isNotEmpty &&
          filter.categoryFilter
              .intersection(app.app.categories.toSet())
              .isEmpty) {
        return false;
      }
      if (filter.sourceFilter.isNotEmpty &&
          sourceProvider
                  .getSource(
                    app.app.url,
                    overrideSource: app.app.overrideSource,
                  )
                  .runtimeType
                  .toString() !=
              filter.sourceFilter) {
        return false;
      }
      return true;
    }).toList();
*/

// ============================================================================
// ALTERNATIVE: Using TextField instead of SearchBar
// ============================================================================
// If you prefer a TextField-based search bar, use this instead:
/*
  Widget _buildSearchBarTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: tr('search'),
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }
*/

// ============================================================================
// STYLING NOTES
// ============================================================================
// The SearchBar implementation uses Material 3 design tokens:
// - surfaceContainerHighest: Background color
// - outlineVariant: Border color
// - onSurfaceVariant: Icon and hint text color
// - primary: Focus state color
// - Border radius: 12 (matches app's design)
// - Padding: 16 horizontal, 12 vertical (consistent with Material 3)
//
// The search filters by:
// 1. App name (case-insensitive)
// 2. Author name (case-insensitive)
// 3. App ID (case-insensitive)
//
// The search works alongside existing filters (name, author, ID, category, source)
// ============================================================================

// ============================================================================
// COMPLETE MODIFIED BUILD METHOD SECTION
// ============================================================================
// Replace the CustomScrollView slivers section with:
/*
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: refresh,
        child: Scrollbar(
          interactive: true,
          controller: scrollController,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            slivers: <Widget>[
              CustomAppBar(title: tr('appsString')),
              // ADD SEARCH BAR HERE
              SliverToBoxAdapter(
                child: _buildSearchBar(context),
              ),
              ...getLoadingWidgets(),
              getDisplayedList(),
            ],
          ),
        ),
      ),
      persistentFooterButtons: appsProvider.apps.isEmpty
          ? null
          : [getFilterButtonsRow()],
    );
*/

// ============================================================================
// TESTING THE IMPLEMENTATION
// ============================================================================
// 1. Type in the search bar to filter apps by name, author, or ID
// 2. The clear button (X) appears when text is entered
// 3. Search works with existing filters (they combine with AND logic)
// 4. The search is case-insensitive
// 5. The search bar styling matches Material 3 and the app's theme
// ============================================================================
