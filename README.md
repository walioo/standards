# service-standards

维护项目的开发交付与代码审查规范，以可复用的 Codex skills 提供。通用流程放在本仓库，项目专属分支、命令、阈值和验收要求由各项目 `AGENTS.md` 定义。

## 工作流入口

| Skill | 用途 |
|---|---|
| [delivery-workflow](skills/delivery-workflow/SKILL.md) | 按项目交付模型编排开发、审查、适用验收、正式交付与清理 |
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

在本工作流调用依赖技能时，依赖提供实施方法；阶段、执行范围和验证深度以当前工作流、用户要求及项目规则为准。依赖中的全量测试、运行验收、文档更新或暂停要求先判断适用性，不因加载依赖就一律执行；项目明确的必需检查、安全约束和授权边界不得省略。

升级依赖时从明确的上游提交重新导入、保留许可证、同步引用文件并复核差异，再更新哈希；结构重构编排中的固定版本清单与校验脚本也须同步，不能只刷新哈希掩盖意外改动。仓库专属规则和用户指令优先于上游示例，命令、阈值和审批要求须结合适用范围判断。

## 知识图谱增强

已有代码知识图谱时，将它用于能力复用、调用链追踪、变更影响分析及回归范围选择，并接入开发、审查和交付交接。先核对索引的仓库与版本，再用当前源码和测试确认结论；工具缺失或索引过期时仍可按基础流程推进。具体接入见[代码知识图谱增强](skills/development-workflow/references/code-knowledge-graph.md)，支持 codebase-memory 或同类工具，不要求安装特定产品。

## 从需求到实现

拿到需求后，使用 `development-workflow` 按以下步骤推进：

1. **需求澄清**：明确使用者、触发场景、预期结果、边界与不做范围；自行调查代码可回答的问题，只询问影响业务行为的关键歧义。
2. **现状与缺口**：追踪入口到数据及副作用，区分已满足、部分满足、缺失和待核实；为判断提供源码、配置、测试或运行证据。
3. **复用调查**：检查现有服务、接口、组件、查询与测试。区分真正缺能力和仅缺接线、开关或权限配置，不重复开发已有功能。
4. **最小方案**：明确复用位置、新增逻辑、责任归属、影响范围与验证方式。只有存在真实取舍时比较方案，不为了设计而增加抽象或依赖。
5. **分步开发**：按完整业务行为推进，留下必要回归检查，逐步实现并验证成功、边界和风险相关失败路径。
6. **整体复核**：对照原需求逐项核对证据，再进行代码审查与后续交付。局部测试通过不能冒充端到端或上线验收。

非平凡任务在编码前简述“需求 → 当前证据 → 缺口 → 可复用能力 → 最小改动与验证”；简单任务可以一段话表达，无需额外长篇文档或固定审批环节。

例如，需求是“课程列表按分类筛选”：若后端已有分类查询参数而前端未传递，先核实权限、分页和分类语义，再考虑复用接口补齐前端接线，不直接新建另一套后端筛选服务。该例仅说明决策方式，不代表任何项目的实际现状。

## 规范边界与交付流程

| 层级 | 内容 |
|---|---|
| service-standards | 阶段、输入输出、基线原则、审查与验收关卡、版本追溯、异常处理及交付状态 |
| 项目 AGENTS.md | 交付模型、分支/环境映射、实际命令、阈值、责任人和专项要求 |
| 项目执行机制 | CI、自动合并、测试隔离、构建部署及业务实现 |

通用规范定义结果和放行条件，项目选择实现手段。项目接入问题在项目清单中处理，不把某个服务的细节变成所有项目的强制步骤。

```text
确认范围与项目基线 → 实现及验证 → 审查 → 适用验收 → 正式交付 → 清理与交接
```

按项目选择简单变更、单任务或批次交付。简单任务可合并步骤；批次任务需核对选定范围、依赖与最终组合。仅分析或审查时止于相应结果，不强制三环境、候选分支或固定平台。

版本、配置和依赖未变化且证据仍适用时继续复用；有变化时重验受影响部分。冲突、取消后恢复和紧急修复保持范围明确、结果可验证，具体操作由项目规定。发布对象必须与验收对象可追溯对应。

详见[交付规范](skills/delivery-workflow/references/delivery-standard.md)。

## 交付质量

代码遵循[最小实现、代码规范与必要注释要求](skills/development-workflow/SKILL.md#代码规范与必要注释)：命名准确、职责清楚、控制流直接，注释解释非显然的原因和约束并随代码更新。开发自检、项目已有工程检查及代码审查共同保障；不以行数、注释比例或新增抽象衡量质量。

交付必须有需求、最终版本与验证证据的对应关系，详见[交付质量门禁](skills/delivery-workflow/references/delivery-standard.md#交付质量门禁)：

- **可提测**：本批需求完整、关键接线完成、必需检查通过、审查必改项处理完毕。
- **可正式合并**：测试验收与最终变化对应，正式合并组合已验证，无其他未验收功能混入。
- **可发布**：代码与产物对应，配置、迁移顺序及必要恢复措施具备。
- **发布验收完成**：线上版本、真实业务路径及项目要求的运行指标得到验证。

失败、缺证据和不适用分别记录；缺少关键验证不能判为通过，非阻断建议与必改项分开处理。覆盖率不能替代行为断言，mock 测试不能代替必要集成验证，CI 通过不能代替测试或发布验收。完整规范提供可直接放进 MR 的交接记录格式。

这些是 skill 的执行规则；自动阻止不合格合并仍需项目配置 CI 与保护分支。

## 调用示例

### 定时确认与夜间持续跟进

支持“每日约定时间确认任务 → 用户选定需求/功能/测试 → goal 持续推进 → 次日查看结果并接续”的流程，建议确认时间为北京时间 17:30。完整规则见[夜间跟进规范](skills/delivery-workflow/references/overnight-follow-up.md)。

提醒仅询问当晚目标；没有回复时不启动新任务。选定目标后明确验收结果、仓库/分支、允许操作和停止条件，沿用既有开发与质量门禁。次日交接完成项、版本/MR、验证证据、未完成项及白天需要的决定。

```text
使用 $delivery-workflow，每天北京时间 17:30 问我今晚有没有需要持续跟进的需求、功能或测试。
今晚的任务由我确认后再启用 goal；不要因无人回复自行开始新任务。
```

```text
今晚用 goal 模式继续课程筛选功能，完成实现、回归检查并创建测试 MR，先不合并。
明早在当前任务给我结果、验证证据和需要继续跟进的事项。
```

安装 skill 不会自动创建定时提醒或 goal。实际启用须调用当前环境提供的调度/goal 能力并确认成功；没有相应能力时说明限制。建议时间属于流程默认建议，具体调度与次日交接时间以用户约定为准。

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

### 按项目模型交付批次

```text
使用 $delivery-workflow，按项目 AGENTS.md 确认基线和交付模型。
本批只包含已选定任务，验证最终组合并关联验收证据；完成已授权交付步骤。
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
| 基线与交付模型 | 权威基线、交付目标、单任务/批次方式及适用分支和环境 |
| Git 与变更请求规则 | 身份、访问方式、命名、合并方式和权限 |
| 工程门禁 | 实际命令、检查范围、阈值、执行副作用及必要专项要求 |
| 审查与验收 | 认可方式、责任人、证据位置和版本关联 |
| 发布与清理 | 发布授权、依赖、恢复/同步方式及留存条件 |
| 自动化接入（适用时） | 项目结果协议、必需门禁和执行权限 |

项目规则与通用流程冲突时先明确适用策略；没有相关环境或自动化的项目不虚构部署或 CI 证据。规范、执行机制与真实运行结果分别验证。

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
