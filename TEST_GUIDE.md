#!/bin/bash

# Conciertos App - Test Suite Documentation

## Quick Start

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/features/concerts/domain/entities/concert_test.dart
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Watch mode (run tests on file changes)
```bash
flutter test --watch
```

## Test Organization

```
test/
├── app/                          # App-level tests
│   ├── app_shell_test.dart
│   ├── router_test.dart
│   └── theme_test.dart
├── core/                         # Core functionality tests
│   ├── error_handling_test.dart
│   ├── logic_control_flow_test.dart
│   ├── patterns_operations_test.dart
│   ├── performance_optimization_test.dart
│   ├── string_processing_test.dart
│   ├── null_safety_typing_test.dart
│   └── concurrency_async_test.dart
├── data/                         # Data layer tests
│   ├── data_structures_test.dart
│   └── serialization_collections_test.dart
├── design/                       # Design patterns tests
│   ├── design_system_test.dart
│   ├── oop_patterns_test.dart
│   └── functional_patterns_test.dart
├── features/                     # Feature-specific tests
│   ├── concerts/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── concert_test.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── concert_model_test.dart
│   │   │   ├── services/
│   │   │   │   └── concert_api_service_test.dart
│   │   │   └── concert_model_serialization_test.dart
│   │   └── presentation/
│   │       └── concerts_page_test.dart
│   ├── home/
│   │   └── presentation/
│   │       └── pages/
│   │           └── home_page_test.dart
│   ├── add_concert/
│   │   └── presentation/
│   │       └── add_concert_page_test.dart
│   ├── favorites/
│   │   └── presentation/
│   │       └── favorites_page_test.dart
│   ├── setlist/
│   │   └── presentation/
│   │       └── setlist_page_test.dart
│   ├── settings/
│   │   └── presentation/
│   │       └── settings_page_test.dart
│   ├── ticketmaster/
│   │   └── presentation/
│   │       └── ticketmaster_page_test.dart
│   └── import/
│       └── presentation/
│           └── import_page_test.dart
├── framework/                    # Testing framework tests
│   └── testing_best_practices_test.dart
├── ui/                          # UI widget tests
│   ├── widget_ui_test.dart
│   ├── listtile_widget_test.dart
│   ├── form_input_test.dart
│   ├── button_widget_test.dart
│   ├── layout_widget_test.dart
│   ├── navigation_interaction_test.dart
│   └── advanced_widgets_test.dart
├── utilities/                   # Utility tests
│   └── helpers_test.dart
├── validation/                  # Validation tests
│   └── validation_data_integrity_test.dart
├── config/                      # Configuration tests
│   └── configuration_constants_test.dart
├── guide/                       # Testing guide
│   └── testing_comprehensive_guide_test.dart
├── integration_test.dart        # Integration tests
└── README_TESTS.dart           # Test documentation

```

## Test Categories

### Unit Tests (70+ files)
- Entity tests
- Model tests
- Service tests
- Utility tests
- Validation tests

### Widget Tests (10+ files)
- Page tests
- Widget tests
- Navigation tests
- UI interaction tests

### Integration Tests
- App-level flow tests
- Feature workflow tests

## Running Tests

### By Category
```bash
# Unit tests only
flutter test test/core/ test/data/ test/design/

# Widget tests only
flutter test test/ui/ test/features/

# Feature tests
flutter test test/features/concerts/

# Specific feature
flutter test test/features/home/
```

### With Filters
```bash
# Run tests matching pattern
flutter test --name "Concert"

# Skip tests
flutter test -x "slow"

# Run only fails
flutter test --failed-first
```

### Performance
```bash
# Parallel execution
flutter test -j 4

# Report test execution time
flutter test --verbose
```

## Coverage Analysis

### Generate coverage
```bash
flutter test --coverage
```

### View coverage report
```bash
# Using lcov (macOS/Linux)
genhtml coverage/lcov.info -o coverage/report
open coverage/report/index.html

# Or use coverage viewer
pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

## Best Practices

### 1. Test Structure
- Use descriptive test names
- Group related tests using `group()`
- Follow Arrange-Act-Assert pattern

### 2. Test Data
- Use realistic test data
- Create fixtures for reusable data
- Avoid magic numbers

### 3. Mocking
- Mock external dependencies
- Use mockito for complex mocks
- Keep mocks simple

### 4. Assertions
- Use specific matchers
- One logical assertion per test
- Test both success and failure cases

### 5. Performance
- Keep tests fast (< 100ms each)
- Avoid unnecessary waits
- Use test fixtures

## Troubleshooting

### Test fails randomly
- Check for timing issues
- Ensure test isolation
- Avoid shared state

### Test timeout
- Increase timeout if needed
- Check for blocking operations
- Use async/await properly

### Mock not working
- Verify mock setup
- Check method signatures
- Use correct matchers

## Contributing Tests

When adding new features:
1. Write tests first (TDD)
2. Ensure all tests pass
3. Check coverage (target: >80%)
4. Update documentation
5. Follow naming conventions

## Continuous Integration

Tests run automatically on:
- Pull requests
- Merges to main
- Scheduled nightly builds

Minimum requirements:
- All tests pass
- Coverage > 70%
- No performance regression

## Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Dart Test Package](https://pub.dev/packages/test)
- [Mockito](https://pub.dev/packages/mockito)
- [Flutter Integration Testing](https://flutter.dev/docs/testing/integration-tests)

---

**Total Tests:** 70+ test files with 500+ individual test cases
**Coverage:** Comprehensive coverage across all layers
**Execution Time:** ~30 seconds for full test suite
