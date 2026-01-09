# Testing Anti-Patterns

## Core Principle

**Test what the code does, not what the mocks do.**

Three fundamental laws:
1. Never test mock behavior
2. Never add test-only methods to production classes
3. Never mock without understanding dependencies

## Anti-Pattern 1: Testing Mock Behavior

**Wrong:** Testing whether a mock exists or was called correctly.

```typescript
// BAD: Testing the mock, not the code
test('calls the API', () => {
  const mockFetch = jest.fn().mockResolvedValue({ data: [] });
  await fetchUsers(mockFetch);
  expect(mockFetch).toHaveBeenCalled(); // Tests mock, not behavior
});
```

**Right:** Test actual component behavior.

```typescript
// GOOD: Testing real behavior
test('returns users from API', () => {
  const result = await fetchUsers();
  expect(result).toHaveLength(3);
  expect(result[0].name).toBe('Alice');
});
```

**Gate function:** Before asserting on a mock, ask: "Am I testing my code or testing my test setup?"

## Anti-Pattern 2: Test-Only Methods in Production

**Wrong:** Adding methods solely for test cleanup.

```typescript
// BAD: Pollutes production code
class UserService {
  private cache = new Map();

  // Added just for tests
  _clearCacheForTesting() {
    this.cache.clear();
  }
}
```

**Right:** Use test utilities or dependency injection.

```typescript
// GOOD: Test controls lifecycle
test('caches user lookups', () => {
  const cache = new Map();
  const service = new UserService({ cache });
  // Test has full control without production pollution
});
```

**Gate function:** Before adding a method, ask: "Would this exist without tests?"

## Anti-Pattern 3: Mocking Without Understanding

**Wrong:** Over-mocking methods without recognizing side effects.

```typescript
// BAD: Mocks away important behavior
jest.spyOn(service, 'validate').mockReturnValue(true);
// What if validate() also sets internal state?
```

**Right:** Understand what you're mocking.

```typescript
// GOOD: Mock specific external dependency
jest.spyOn(externalApi, 'fetch').mockResolvedValue(testData);
// Internal logic runs normally
```

**Gate function:** Before mocking, ask: "What else does this method do?"

## Anti-Pattern 4: Incomplete Mocks

**Wrong:** Mock responses missing fields used downstream.

```typescript
// BAD: Incomplete mock
mockApi.getUser.mockResolvedValue({ id: 1 });
// Code later accesses user.email - undefined!
```

**Right:** Mock complete structures.

```typescript
// GOOD: Complete mock
mockApi.getUser.mockResolvedValue({
  id: 1,
  email: 'test@example.com',
  name: 'Test User',
  createdAt: new Date().toISOString(),
});
```

**Gate function:** Before using a mock, ask: "Does this have all fields the real response has?"

## Anti-Pattern 5: Tests as Afterthought

**Wrong:** Write code first, add tests later.

```typescript
// Developer flow: implement → manual test → add unit test
// Result: Tests that pass immediately prove nothing
```

**Right:** TDD - tests guide implementation.

```typescript
// TDD flow: write test → watch fail → implement → watch pass
// Result: Tests prove implementation works
```

**Gate function:** Before writing code, ask: "Where's the failing test?"

## Complex Mocks Signal Problems

If your test setup requires:
- More than 3 mocks
- Nested mock configurations
- Mock implementation details

Consider:
- Integration test instead
- Refactoring to reduce dependencies
- Testing at a different level

## Summary

| Anti-Pattern | Symptom | Fix |
|--------------|---------|-----|
| Testing mocks | Assert on mock calls | Assert on behavior |
| Test-only methods | `_forTesting()` methods | Dependency injection |
| Blind mocking | Mock everything | Mock only externals |
| Incomplete mocks | Undefined errors | Mirror real structure |
| Tests last | Tests pass immediately | Write tests first |

**The safest test is one that uses real code with minimal mocking.**
