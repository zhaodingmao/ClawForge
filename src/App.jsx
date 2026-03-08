import { useMemo, useState } from "react";

const translations = {
  zh: {
    brand: "ClawForge",
    tagline: "OpenClaw AI Agent 一键安装器",
    navInstall: "安装",
    navFeatures: "特性",
    navUsage: "用法",
    navFaq: "常见问题",
    heroBadge: "跨平台 · Linux / macOS / Windows",
    heroTitle: "一条命令安装并启动 OpenClaw。",
    heroDesc:
        "ClawForge 是一个轻量级安装器，专注于帮助你快速完成 OpenClaw AI agent runtime 的安装与启动。减少环境配置成本，把注意力放回 agent 本身。",
    ctaStart: "立即开始",
    ctaGithub: "查看 GitHub",
    oneCommand: "一条命令安装",
    terminalTitle: "安装预览",
    featuresTitle: "为什么选择 ClawForge",
    featuresDesc: "专注快速安装，保持简单、稳定、可扩展。",
    feature1Title: "一条命令安装",
    feature1Desc: "直接从终端安装 OpenClaw，减少手工配置步骤。",
    feature2Title: "多平台支持",
    feature2Desc: "覆盖 Linux、macOS 和 Windows 的安装流程。",
    feature3Title: "自动化配置",
    feature3Desc: "自动处理基础运行环境与项目初始化流程。",
    feature4Title: "开源可扩展",
    feature4Desc: "便于审查、二次开发和集成到你自己的工作流中。",
    installLabel: "安装",
    installTitle: "几秒开始使用",
    installDesc: "Linux 或 macOS 使用安装脚本，安装完成后直接运行 OpenClaw。",
    windowsLabel: "Windows",
    windowsTitle: "PowerShell 安装",
    windowsDesc: "通过 PowerShell 进行安装，完成后直接启动 OpenClaw。",
    usageLabel: "用法",
    usageTitle: "安装器会做什么",
    usageDesc: "ClawForge 专注于为 OpenClaw AI agents 提供顺滑的启动路径。",
    step1: "检测你的平台并选择对应安装流程。",
    step2: "确保 Git 和 Node.js 可用。",
    step3: "下载或更新 OpenClaw 仓库。",
    step4: "安装项目依赖。",
    step5: "创建 openclaw 启动命令，便于直接运行。",
    faqLabel: "常见问题",
    faqTitle: "你可能想知道",
    faq1Q: "ClawForge 是什么？",
    faq1A: "一个专注于快速安装 OpenClaw AI agents 的轻量安装器。",
    faq2Q: "支持 Windows 吗？",
    faq2A: "支持。可以直接使用页面里的 PowerShell 安装命令。",
    faq3Q: "它是开源的吗？",
    faq3A: "是。项目设计目标就是便于查看、修改和扩展。",
    faq4Q: "源码在哪里？",
    faq4A: "GitHub：github.com/zhaodingmao/ClawForge。",
    footerTagline: "OpenClaw AI agents 一条命令安装器",
    langLabel: "语言",
  },
  en: {
    brand: "ClawForge",
    tagline: "One-command installer for OpenClaw AI agents",
    navInstall: "Install",
    navFeatures: "Features",
    navUsage: "Usage",
    navFaq: "FAQ",
    heroBadge: "Cross-platform · Linux / macOS / Windows",
    heroTitle: "Install and launch OpenClaw with one command.",
    heroDesc:
        "ClawForge is a lightweight installer focused on getting the OpenClaw AI agent runtime up and running fast. Spend less time on setup and more time on your agents.",
    ctaStart: "Get Started",
    ctaGithub: "View on GitHub",
    oneCommand: "One-command install",
    terminalTitle: "Install preview",
    featuresTitle: "Why ClawForge",
    featuresDesc: "Built for fast setup. Simple, stable, and ready to extend.",
    feature1Title: "One-command install",
    feature1Desc: "Install OpenClaw directly from your terminal with minimal friction.",
    feature2Title: "Cross-platform",
    feature2Desc: "Supports Linux, macOS, and Windows installation flows.",
    feature3Title: "Automatic setup",
    feature3Desc: "Handles the core runtime prerequisites and project bootstrap steps.",
    feature4Title: "Open source",
    feature4Desc: "Easy to inspect, customize, and integrate into your own workflow.",
    installLabel: "Install",
    installTitle: "Get started in seconds",
    installDesc: "Use the install script for Linux or macOS, then run OpenClaw directly.",
    windowsLabel: "Windows",
    windowsTitle: "PowerShell install",
    windowsDesc: "Install from PowerShell and start OpenClaw once setup completes.",
    usageLabel: "Usage",
    usageTitle: "What the installer does",
    usageDesc: "ClawForge focuses on a smooth bootstrap path for OpenClaw AI agents.",
    step1: "Detects your platform and selects the right install flow.",
    step2: "Ensures Git and Node.js are available.",
    step3: "Downloads or updates the OpenClaw repository.",
    step4: "Installs project dependencies.",
    step5: "Creates a convenient openclaw command for launching the runtime.",
    faqLabel: "FAQ",
    faqTitle: "Common questions",
    faq1Q: "What is ClawForge?",
    faq1A: "A lightweight installer focused on getting OpenClaw AI agents running quickly.",
    faq2Q: "Does it support Windows?",
    faq2A: "Yes. Use the PowerShell install command shown above.",
    faq3Q: "Is it open source?",
    faq3A: "Yes. The project is designed to be easy to inspect and extend.",
    faq4Q: "Where can I find the source?",
    faq4A: "On GitHub at github.com/zhaodingmao/ClawForge.",
    footerTagline: "One-command installer for OpenClaw AI agents",
    langLabel: "Language",
  },
};

function LangSwitch({ lang, setLang, t }) {
  return (
      <div className="inline-flex items-center gap-2 rounded-2xl border border-zinc-700 bg-zinc-900/80 p-1 text-sm">
        <span className="px-2 text-zinc-400">{t.langLabel}</span>
        <button
            onClick={() => setLang("zh")}
            className={`rounded-xl px-3 py-1.5 transition ${
                lang === "zh" ? "bg-blue-500 text-white" : "text-zinc-300 hover:bg-zinc-800"
            }`}
        >
          中文
        </button>
        <button
            onClick={() => setLang("en")}
            className={`rounded-xl px-3 py-1.5 transition ${
                lang === "en" ? "bg-blue-500 text-white" : "text-zinc-300 hover:bg-zinc-800"
            }`}
        >
          EN
        </button>
      </div>
  );
}

export default function App() {
  const [lang, setLang] = useState("zh");
  const t = useMemo(() => translations[lang], [lang]);

  return (
      <div className="min-h-screen bg-zinc-950 text-zinc-100">
        <header className="relative overflow-hidden border-b border-zinc-800 bg-gradient-to-b from-zinc-900 via-zinc-950 to-zinc-950">
          <div className="absolute inset-0 bg-[radial-gradient(circle_at_top,rgba(59,130,246,0.18),transparent_35%),radial-gradient(circle_at_80%_20%,rgba(16,185,129,0.14),transparent_30%)]" />
          <div className="relative mx-auto max-w-6xl px-4 py-8 sm:px-6 sm:py-10 lg:px-8 lg:py-16">
            <div className="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
              <div className="flex items-center gap-3">
                <div className="flex h-11 w-11 items-center justify-center rounded-2xl border border-zinc-700 bg-zinc-900 shadow-lg shadow-blue-950/30">
                  <span className="text-xl font-bold text-blue-400">C</span>
                </div>
                <div>
                  <div className="text-xl font-semibold tracking-tight">{t.brand}</div>
                  <div className="text-sm text-zinc-400">{t.tagline}</div>
                </div>
              </div>

              <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between lg:justify-end">
                <nav className="flex flex-wrap gap-4 text-sm text-zinc-300 sm:gap-6">
                  <a href="#install" className="hover:text-white">{t.navInstall}</a>
                  <a href="#features" className="hover:text-white">{t.navFeatures}</a>
                  <a href="#usage" className="hover:text-white">{t.navUsage}</a>
                  <a href="#faq" className="hover:text-white">{t.navFaq}</a>
                </nav>
                <LangSwitch lang={lang} setLang={setLang} t={t} />
              </div>
            </div>

            <div className="mt-12 grid items-center gap-10 lg:mt-16 lg:grid-cols-[1.1fr_0.9fr] lg:gap-12">
              <div>
                <div className="mb-4 inline-flex items-center rounded-full border border-blue-500/30 bg-blue-500/10 px-3 py-1 text-sm text-blue-300">
                  {t.heroBadge}
                </div>
                <h1 className="max-w-3xl text-4xl font-bold tracking-tight text-white sm:text-5xl lg:text-6xl">
                  {t.heroTitle}
                </h1>
                <p className="mt-6 max-w-2xl text-base leading-8 text-zinc-300 sm:text-lg">
                  {t.heroDesc}
                </p>
                <div className="mt-8 flex flex-col gap-3 sm:flex-row sm:flex-wrap">
                  <a
                      href="#install"
                      className="rounded-2xl bg-blue-500 px-5 py-3 text-center text-sm font-semibold text-white shadow-lg shadow-blue-950/40 transition hover:bg-blue-400"
                  >
                    {t.ctaStart}
                  </a>
                  <a
                      href="https://github.com/zhaodingmao/ClawForge"
                      className="rounded-2xl border border-zinc-700 px-5 py-3 text-center text-sm font-semibold text-zinc-200 transition hover:border-zinc-500 hover:bg-zinc-900"
                  >
                    {t.ctaGithub}
                  </a>
                </div>
                <div className="mt-8 rounded-3xl border border-zinc-800 bg-zinc-900/70 p-4 shadow-2xl shadow-black/20 backdrop-blur">
                  <div className="mb-2 text-xs uppercase tracking-[0.2em] text-zinc-500">{t.oneCommand}</div>
                  <div className="overflow-x-auto rounded-2xl bg-black px-4 py-4 font-mono text-sm text-emerald-300">
                    curl -fsSL https://clawforge.com.cn/install.sh | bash
                  </div>
                </div>
              </div>

              <div className="rounded-[2rem] border border-zinc-800 bg-zinc-900/80 p-4 shadow-2xl shadow-black/30 backdrop-blur sm:p-5">
                <div className="rounded-[1.5rem] border border-zinc-800 bg-black p-4">
                  <div className="mb-4 flex items-center gap-2">
                    <div className="h-3 w-3 rounded-full bg-red-400" />
                    <div className="h-3 w-3 rounded-full bg-yellow-400" />
                    <div className="h-3 w-3 rounded-full bg-green-400" />
                  </div>
                  <div className="mb-3 text-xs uppercase tracking-[0.2em] text-zinc-500">{t.terminalTitle}</div>
                  <pre className="overflow-x-auto whitespace-pre-wrap font-mono text-xs leading-6 text-zinc-200 sm:text-sm sm:leading-7">
{`$ curl -fsSL https://clawforge.com.cn/install.sh | bash
[INFO] Installing ClawForge...
[INFO] Detecting platform...
[INFO] Installing Node.js and Git...
[INFO] Downloading OpenClaw...
[INFO] Installing dependencies...
[INFO] Creating openclaw command...

$ openclaw
[INFO] OpenClaw runtime started.`}
                </pre>
                </div>
              </div>
            </div>
          </div>
        </header>

        <main className="mx-auto max-w-6xl px-4 py-16 sm:px-6 sm:py-20 lg:px-8">
          <section id="features">
            <div className="max-w-2xl">
              <h2 className="text-3xl font-bold tracking-tight text-white sm:text-4xl">{t.featuresTitle}</h2>
              <p className="mt-4 text-zinc-400">{t.featuresDesc}</p>
            </div>
            <div className="mt-10 grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
              {[
                { title: t.feature1Title, desc: t.feature1Desc },
                { title: t.feature2Title, desc: t.feature2Desc },
                { title: t.feature3Title, desc: t.feature3Desc },
                { title: t.feature4Title, desc: t.feature4Desc },
              ].map((item) => (
                  <div key={item.title} className="rounded-3xl border border-zinc-800 bg-zinc-900 p-6 shadow-lg shadow-black/20">
                    <div className="text-lg font-semibold text-white">{item.title}</div>
                    <p className="mt-3 text-sm leading-7 text-zinc-400">{item.desc}</p>
                  </div>
              ))}
            </div>
          </section>

          <section id="install" className="mt-24 grid gap-8 lg:grid-cols-2">
            <div className="rounded-[2rem] border border-zinc-800 bg-zinc-900 p-6 sm:p-8">
              <div className="text-sm font-medium uppercase tracking-[0.2em] text-blue-300">{t.installLabel}</div>
              <h3 className="mt-4 text-3xl font-bold text-white">{t.installTitle}</h3>
              <p className="mt-4 text-zinc-400">{t.installDesc}</p>
              <div className="mt-6 overflow-x-auto rounded-2xl bg-black p-4 font-mono text-sm text-emerald-300">
                curl -fsSL https://clawforge.com.cn/install.sh | bash
              </div>
              <div className="mt-4 overflow-x-auto rounded-2xl bg-black p-4 font-mono text-sm text-zinc-200">
                openclaw
              </div>
            </div>

            <div className="rounded-[2rem] border border-zinc-800 bg-zinc-900 p-6 sm:p-8">
              <div className="text-sm font-medium uppercase tracking-[0.2em] text-emerald-300">{t.windowsLabel}</div>
              <h3 className="mt-4 text-3xl font-bold text-white">{t.windowsTitle}</h3>
              <p className="mt-4 text-zinc-400">{t.windowsDesc}</p>
              <div className="mt-6 overflow-x-auto rounded-2xl bg-black p-4 font-mono text-sm text-sky-300">
                irm https://clawforge.com.cn/install.ps1 | iex
              </div>
              <div className="mt-4 overflow-x-auto rounded-2xl bg-black p-4 font-mono text-sm text-zinc-200">
                openclaw
              </div>
            </div>
          </section>

          <section id="usage" className="mt-24 grid gap-8 lg:grid-cols-[0.9fr_1.1fr]">
            <div>
              <div className="text-sm font-medium uppercase tracking-[0.2em] text-violet-300">{t.usageLabel}</div>
              <h3 className="mt-4 text-3xl font-bold text-white">{t.usageTitle}</h3>
              <p className="mt-4 text-zinc-400">{t.usageDesc}</p>
            </div>
            <div className="rounded-[2rem] border border-zinc-800 bg-zinc-900 p-6 sm:p-8">
              <ol className="space-y-5 text-zinc-300">
                {[t.step1, t.step2, t.step3, t.step4, t.step5].map((step, index) => (
                    <li key={step} className="flex gap-4">
                      <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-zinc-800 text-sm font-semibold text-white">
                        {index + 1}
                      </div>
                      <div className="pt-1 leading-7">{step}</div>
                    </li>
                ))}
              </ol>
            </div>
          </section>

          <section id="faq" className="mt-24">
            <div className="max-w-2xl">
              <div className="text-sm font-medium uppercase tracking-[0.2em] text-amber-300">{t.faqLabel}</div>
              <h3 className="mt-4 text-3xl font-bold text-white">{t.faqTitle}</h3>
            </div>
            <div className="mt-8 grid gap-5 sm:grid-cols-2">
              {[
                { q: t.faq1Q, a: t.faq1A },
                { q: t.faq2Q, a: t.faq2A },
                { q: t.faq3Q, a: t.faq3A },
                { q: t.faq4Q, a: t.faq4A },
              ].map((item) => (
                  <div key={item.q} className="rounded-3xl border border-zinc-800 bg-zinc-900 p-6">
                    <div className="text-lg font-semibold text-white">{item.q}</div>
                    <p className="mt-3 text-sm leading-7 text-zinc-400">{item.a}</p>
                  </div>
              ))}
            </div>
          </section>
        </main>

        <footer className="border-t border-zinc-800 bg-zinc-950">
          <div className="mx-auto flex max-w-6xl flex-col gap-6 px-4 py-10 text-sm text-zinc-400 sm:px-6 md:flex-row md:items-center md:justify-between lg:px-8">
            <div>
              <div className="font-semibold text-zinc-200">{t.brand}</div>
              <div className="mt-1">{t.footerTagline}</div>
            </div>
            <div className="flex flex-wrap gap-5">
              <a href="https://clawforge.com.cn" className="hover:text-white">Website</a>
              <a href="https://github.com/zhaodingmao/ClawForge" className="hover:text-white">GitHub</a>
            </div>
          </div>
        </footer>
      </div>
  );
}