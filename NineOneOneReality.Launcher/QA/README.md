# QA proof artifacts

| File | Purpose |
|------|---------|
| `build-and-smoke-proof.txt` | Timestamped log from `tools/Run-BuildProof.ps1` (dotnet restore, Release build, smoke matrix) |

Regenerate before each delivery:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\Run-BuildProof.ps1
```
