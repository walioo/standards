# service-standards

维护项目的开发交付与代码审查规范，以可复用的 Codex skills 提供。通用流程放在本仓库，项目专属分支、命令、阈值和验收要求由各项目 `AGENTS.md` 定义。

## 工作流入口

| Skill | 用途 |
|---|---|
| [delivery-workflow](skills/delivery-workflow/SKILL.md) | 从正式基线建分支，编排开发、审查、测试 MR、验收、正式 MR 和分支清理 |
| [development-workflow](skills/development-workflow/SKILL.md) | 澄清需求与验收场景、调查功能缺口、核实复用能力、选择最小实现，分步开发和验证 |
| [code-review-workflow](skills/code-review-workflow/SKILL.md) | 审查覆盖率、正确性、代码质量、架构、安全、性能与兼容性 |

流程细节统一维护在[完整开发交付规范](skills/delivery-workflow/references/delivery-standard.md)。

## 安装

安装三个工作流及随附的成熟技能依赖。在本仓库根目录执行以下命令，先替换示例项目路径；只需系统 Git、Python 3（格式校验时使用）和 `shasum`，安装不联网：

```bash
(
  set -eu
  project_root=/absolute/path/to/project
  standards_root="$PWD"
  shasum -a 256 -c dependencies.sha256
  for source in skills/*; do
    target="$project_root/.codex/skills/$(basename "$source")"
    if [ -e "$target" ] && ! diff -qr "$source" "$target" >/dev/null; then
      echo "存在不同版本，请先比较并处理：$target" >&2
      exit 1
    fi
  done
  mkdir -p "$project_root/.codex/skills"
  for source in skills/*; do
    target="$project_root/.codex/skills/$(basename "$source")"
    if [ ! -e "$target" ]; then cp -R "$source" "$target"; fi
  done
  cd "$project_root/.codex"
  shasum -a 256 -c "$standards_root/dependencies.sha256"
)
```

保留 `SKILL.md`、`agents/` 和 `references/` 的目录结构。在目标项目技能列表中确认可见后调用；当前会话未识别时，新开会话并明确提供 `SKILL.md` 路径。更新前比较差异，不覆盖项目自己的修改。

### 成熟技能依赖

本仓库包含交付、开发、审查三个工作流及所需依赖。`development-workflow` 基于已有同名开发流程补充需求澄清、缺口分析与复用决策，可独立执行基础开发闭环。安装遇到不同版本会在复制前退出；先比较并选择版本，不自动覆盖或混装。

上游技能来自 [addyosmani/agent-skills 固定版本](https://github.com/addyosmani/agent-skills/tree/7829ffd90d973b6325f5f12f1b1226dcace74443)，采用 MIT 许可，每个上游技能目录保留 `LICENSE`。上游 `SKILL.md` 原样保留，共享参考文档复制到各技能的 `references/`，便于独立解析。

`safe-structured-refactor` 和 `structured-refactor-workflow` 为现有本地编排技能快照，不宣称来自该上游。它们及上游技能的逐文件 SHA-256 固定在 [dependencies.sha256](dependencies.sha256)，包括参考文件、元数据及校验脚本；由本仓库版本记录追踪升级。

| 用途 | Skill |
|---|---|
| 多维代码审查 | `code-review-and-quality` |
| 测试有效性与回归保护 | `test-driven-development` |
| 安全专项 | `security-and-hardening` |
| 性能专项 | `performance-optimization` |
| 按需：接口、调试、任务拆分与渐进实现 | `api-and-interface-design`、`debugging-and-error-recovery`、`planning-and-task-breakdown`、`incremental-implementation` |
| 按需：结构重构 | `structured-refactor-workflow`、`safe-structured-refactor` |
| 传递依赖 | `using-agent-skills`、`spec-driven-development`、`context-engineering`、`doubt-driven-development`、`deprecation-and-migration`、`code-simplification` |

依赖随包安装，执行仍按风险选择技能，不要求每个任务全部运行。上游文本中的 `skills/<名称>/SKILL.md` 表示已安装的同名技能，不是在当前 skill 下再创建 `skills/`；从会话技能目录解析。缺失或校验不一致时先修复安装，不宣称已执行对应流程。

升级依赖时从明确的上游提交重新导入、保留许可证、同步引用文件并复核差异，再更新哈希；结构重构编排中的固定版本清单与校验脚本也须同步，不能只刷新哈希掩盖意外改动。仓库专属规则和用户指令优先于上游示例，命令、阈值和审批要求须结合适用范围判断。

## 从需求到实现

拿到需求后，先使用 `development-workflow` 完成以下步骤，再进入编码：

1. **需求澄清**：明确使用者、触发场景、预期结果、边界与不做范围；自行调查代码可回答的问题，只询问影响业务行为的关键歧义。
2. **现状与缺口**：追踪入口到数据及副作用，区分已满足、部分满足、缺失和待核实；为判断提供源码、配置、测试或运行证据。
3. **复用调查**：检查现有服务、接口、组件、查询与测试。区分真正缺能力和仅缺接线、开关或权限配置，不重复开发已有功能。
4. **最小方案**：明确复用位置、新增逻辑、责任归属、影响范围与验证方式。只有存在真实取舍时比较方案，不为了设计而增加抽象或依赖。
5. **分步开发**：按完整业务行为推进，留下必要回归检查，逐步实现并验证成功、边界和风险相关失败路径。
6. **整体复核**：对照原需求逐项核对证据，再进行代码审查与后续交付。局部测试通过不能冒充端到端或上线验收。

非平凡任务在编码前简述“需求 → 当前证据 → 缺口 → 可复用能力 → 最小改动与验证”；简单任务可以一段话表达，无需额外长篇文档或固定审批环节。

例如，需求是“课程列表按分类筛选”：若后端已有分类查询参数而前端未传递，先核实权限、分页和分类语义，再考虑复用接口补齐前端接线，不直接新建另一套后端筛选服务。该例仅说明决策方式，不代表任何项目的实际现状。

## 交付流程

```text
需求澄清 → 现状与缺口 → 复用调查 → 最小实现方案
  → 最新正式基线 main / release
  → feat/业务描述 或 fix/问题描述
  → 开发与本地验证
  → 代码审查
  → MR 到 dev / test
  → 测试环境部署与验收
  → 原任务分支 MR 到 main / release
  → 正式合并核实后删除任务分支
```

分支角色以项目配置为准，不能仅凭名称猜测。关键规则：

- 分支、提交和 MR 标题描述业务变化，不添加 AI 工具署名。
- 测试 MR 合并后保留源分支，验收通过前不创建正式 MR。
- 不把 dev/test 合并回正式交付的任务分支；测试目标冲突使用规范中的临时集成分支方案。
- 验收绑定代码 SHA 和部署版本；后续改动或冲突解决后，重新验证受影响场景。
- CI 成功、MR 合并、部署成功不能替代业务验收。
- 正式合并后核实完整变更、未保存工作及其他待处理 MR，再清理分支。合并、部署按已有授权执行。

## 交付质量

交付必须有需求、最终版本与验证证据的对应关系，详见[交付质量门禁](skills/delivery-workflow/references/delivery-standard.md#交付质量门禁)：

- **可提测**：本批需求完整、关键接线完成、必需检查通过、审查必改项处理完毕。
- **可正式合并**：测试验收与最终变化对应，正式合并组合已验证，无其他未验收功能混入。
- **可发布**：代码与产物对应，配置、迁移顺序及必要恢复措施具备。
- **发布验收完成**：线上版本、真实业务路径及项目要求的运行指标得到验证。

失败、缺证据和不适用分别记录；缺少关键验证不能判为通过，非阻断建议与必改项分开处理。覆盖率不能替代行为断言，mock 测试不能代替必要集成验证，CI 通过不能代替测试或发布验收。完整规范提供可直接放进 MR 的交接记录格式。

这些是 skill 的执行规则；自动阻止不合格合并仍需项目配置 CI 与保护分支。本次没有自动修改任何业务仓库的 CI 或分支保护。

## 调用示例

### 拿到需求，先分析再开发

```text
使用 $development-workflow 实现课程分类筛选。
先调查现有实现和功能缺口，给出可复用能力与最小改动方案；关键业务歧义再问我，明确后继续实现和验证。
```

### 仅分析，不编码

```text
使用 $development-workflow 分析这个需求，先不要改代码。
列出验收场景、当前实现证据、功能缺口、可复用能力及最小实现建议。
```

### 开发功能并提测

```text
使用 $delivery-workflow 实现课程分类筛选。
按仓库 AGENTS.md 确认正式基线和测试目标，完成开发、验证与审查后创建测试 MR，等待验收。
```

### 修复缺陷

```text
使用 $delivery-workflow 修复订单重复退款问题。
先追踪调用链并建立回归检查，从正式基线创建 fix 分支，验证权限、幂等和事务失败路径后提测。
```

### 独立代码审查

```text
使用 $code-review-workflow 审查当前分支相对目标分支的改动。
检查覆盖率、关键断言、代码质量、安全和性能；先只输出问题、验证证据与缺口，不修改代码。
```

### 验收后继续交付

```text
使用 $delivery-workflow 继续当前任务。
核实测试验收记录与当前代码版本一致，通过最终审查后创建正式 MR；先不合并或部署。
```

审查结论区分“通过”“需修改”“验证不足”；未采集或不支持的覆盖率指标明确标注，不编造百分比，不默认采用统一阈值。

## 项目接入配置

在项目 `AGENTS.md` 中填写真实规则：

| 配置项 | 内容 |
|---|---|
| 正式基线/正式 MR 目标 | main、release 或具体 release/*；多个正式目标的同步顺序 |
| 测试 MR 目标 | dev 或 test，对应环境和部署方式 |
| Git 规则 | 提交人姓名/邮箱、远端访问方式、命名、合并策略和保护分支权限 |
| 工程门禁 | 格式、构建、类型、测试、覆盖率、安全和性能的实际命令与阈值 |
| 测试验收 | 负责人、验收场景、记录位置和版本关联方式 |
| 发布与清理 | 发布授权、回滚依据、分支保留与删除条件 |

仓库规则与通用流程冲突时，先明确项目策略，不静默覆盖。没有 dev/test 的规范或文档仓库不虚构测试分支和业务验收记录，应按该仓库明确的文档评审流程交付。

## 维护

提交前可运行以下检查，安装测试在临时目录执行并自动清理，不修改已有安装：

```bash
shasum -a 256 -c dependencies.sha256
sh skills/structured-refactor-workflow/scripts/verify-upstream-skills.sh
python3 tests/test_installation.py
git diff --check
```

- `skills/` 是发布源，复制到其他项目后需主动同步更新。
- 通用技能保持跨项目、跨语言，不写入私人绝对路径、凭证、业务数据或项目独有阈值。
- 修改流程时同步入口、参考文件及 README 用法，检查相对链接与技能元数据。
- 这些 skills 提供执行指导，不会自行安装 Git hooks、CI 门禁或后台自动化。
