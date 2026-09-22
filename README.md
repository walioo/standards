# service-standards

维护项目的开发交付与代码审查规范，以可复用的 Codex skills 提供。通用流程放在本仓库，项目专属分支、命令、阈值和验收要求由各项目 `AGENTS.md` 定义。

## 工作流入口

| Skill | 用途 |
|---|---|
| [delivery-workflow](skills/delivery-workflow/SKILL.md) | 从正式基线建分支，编排开发、审查、测试 MR、验收、正式 MR 和分支清理 |
| [code-review-workflow](skills/code-review-workflow/SKILL.md) | 审查覆盖率、正确性、代码质量、架构、安全、性能与兼容性 |

流程细节统一维护在[完整开发交付规范](skills/delivery-workflow/references/delivery-standard.md)。

## 安装

将整个 skill 目录复制到目标项目的 `.codex/skills/`。在本仓库根目录执行以下命令，先替换示例项目路径：

```bash
project_root=/absolute/path/to/project
mkdir -p "$project_root/.codex/skills"
for skill in delivery-workflow code-review-workflow; do
  if [ -e "$project_root/.codex/skills/$skill" ]; then
    echo "已存在，先比较再更新：$skill"
  else
    cp -R "skills/$skill" "$project_root/.codex/skills/$skill"
  fi
done
```

保留 `SKILL.md`、`agents/` 和 `references/` 的目录结构。在目标项目技能列表中确认可见后调用；当前会话未识别时，新开会话并明确提供 `SKILL.md` 路径。更新前比较差异，不覆盖项目自己的修改。

### 成熟技能依赖

本仓库提供两个工作流入口，**不包含以下成熟技能的副本**。团队需在目标环境准备对应技能；执行时按会话技能目录定位，不依赖固定用户路径。

| 用途 | Skill |
|---|---|
| 开发执行 | `development-workflow` |
| 多维代码审查 | `code-review-and-quality` |
| 测试有效性与回归保护 | `test-driven-development` |
| 安全专项 | `security-and-hardening` |
| 性能专项 | `performance-optimization` |
| 按需：接口、调试、任务拆分与渐进实现 | `api-and-interface-design`、`debugging-and-error-recovery`、`planning-and-task-breakdown`、`incremental-implementation` |
| 按需：结构重构 | `structured-refactor-workflow`、`safe-structured-refactor`，以及它们声明的依赖 |

专项技能按风险使用，不要求每个任务全部运行。技能缺失时报告限制，不得宣称执行过缺失流程。依赖来源与版本由团队维护，本仓库不自动下载或安装依赖。

## 交付流程

```text
最新正式基线 main / release
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

## 调用示例

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

- `skills/` 是发布源，复制到其他项目后需主动同步更新。
- 通用技能保持跨项目、跨语言，不写入私人绝对路径、凭证、业务数据或项目独有阈值。
- 修改流程时同步入口、参考文件及 README 用法，检查相对链接与技能元数据。
- 这些 skills 提供执行指导，不会自行安装 Git hooks、CI 门禁或后台自动化。
