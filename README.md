# Feder

Feder is a social journal where you can make private entries 
and selectively share them.

## Project structure

The modules are colocated within relevant domains. 

```diff
- lib/feder_web/
- test/
! lib/feder
! lib/feder/<domain>.ex
! lib/feder/<domain>/*.ex
+ lib/feder/<domain>/*.live.ex
+ lib/feder/<domain>/*.test.ex
```

Modules can reference all parents, children and siblings in 
the same directory. But cannot access other domains in 
parents' directories.

```mermaid
graph TD
subgraph lib/demo/
  parents --- module & siblings & other_domains

  subgraph ./foo/
    module --- children & siblings
    siblings --- children

    subgraph ./baz/
      children
    end
  end

  subgraph ./qux/
    other_domains 
  end

  module & siblings & children x-.-x other_domains
end
```

`config.exs` is renamed to remove repetition.

```diff
- config/config.exs
+ config/base.exs
```
