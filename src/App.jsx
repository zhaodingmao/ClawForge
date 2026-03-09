import { useEffect, useMemo, useState } from "react";

const translations = {
  zh: {
    brand: "ClawForge",
    tagline: "OpenClaw AI Agent 一键安装器",
    navInstall: "安装",
    navFeatures: "特性",
    navUsage: "用法",
    navFaq: "常见问题",
    heroBadge: "跨平台 · Linux / macOS / Windows",
    heroTitle: "一条命令安装 OpenClaw。",
    heroDesc:
      "ClawForge 是一个轻量级安装器，专注于帮助你快速完成 OpenClaw AI agent runtime 的安装与启动。减少环境配置成本，把注意力放回 agent 本身。",
    ctaStart: "开始安装",
    ctaGithub: "GitHub",
    oneCommand: "当前系统推荐命令",
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
    installLabel: "安装与初始化",
    installTitle: "按系统选择安装方式",
    installDesc:
      "页面会自动识别当前系统，并展示对应命令。你也可以手动查看 Linux / macOS 与 Windows 的完整安装流程。",
    linuxLabel: "Linux / macOS",
    linuxTitle: "Shell 安装命令",
    linuxDesc: "适用于 Linux 与 macOS 终端环境。安装完成后即可开始初始化 OpenClaw。",
    windowsLabel: "Windows",
    windowsTitle: "PowerShell 安装命令",
    windowsDesc: "适用于 Windows PowerShell。安装完成后建议重启终端，再进行初始化。",
    initLabel: "初始化",
    initTitle: "安装完成后如何初始化 OpenClaw",
    initDesc: "安装命令执行成功后，建议先完成初始化与健康检查，再开始连接渠道或配置模型。",
    initStep1Title: "1. 运行初始化向导",
    initStep1Desc: "安装完成后先执行 onboard，引导创建本地配置与服务。",
    initStep2Title: "2. 检查运行状态",
    initStep2Desc: "运行 doctor 确认环境、依赖和服务是否正常。",
    initStep3Title: "3. 继续配置",
    initStep3Desc: "根据需要执行 configure、models、channels 等命令完成后续接入。",
    usageLabel: "用法",
    usageTitle: "安装器会做什么",
    usageDesc: "ClawForge 专注于为 OpenClaw AI agents 提供顺滑的启动路径。",
    step1: "检测你的平台并选择对应安装流程。",
    step2: "确保 Git 和 Node.js 可用。",
    step3: "安装 OpenClaw CLI。",
    step4: "写入 PATH 并创建可直接运行的命令。",
    step5: "引导你完成 onboard 初始化配置。",
    faqLabel: "常见问题",
    faqTitle: "你可能想知道",
    faq1Q: "ClawForge 是什么？",
    faq1A: "一个专注于快速安装 OpenClaw AI agents 的轻量安装器。",
    faq2Q: "支持 Windows 吗？",
    faq2A: "支持。页面会显示 PowerShell 安装命令。",
    faq3Q: "它是开源的吗？",
    faq3A: "是。项目设计目标就是便于查看、修改和扩展。",
    faq4Q: "安装后第一步应该做什么？",
    faq4A: "先运行 openclaw onboard --install-daemon，然后再执行 openclaw doctor。",
    footerTagline: "OpenClaw AI agents 一条命令安装器",
    langLabel: "语言",
    langZh: "中文",
    langEn: "English",
    copy: "复制",
    copied: "已复制",
    copySuccess: "命令已复制到剪贴板",
    copyFailed: "复制失败，请手动复制",
  },
  en: {
    brand: "ClawForge",
    tagline: "One-command installer for OpenClaw AI agents",
    navInstall: "Install",
    navFeatures: "Features",
    navUsage: "Usage",
    navFaq: "FAQ",
    heroBadge: "Cross-platform · Linux / macOS / Windows",
    heroTitle: "Install OpenClaw with one command.",
    heroDesc:
      "ClawForge is a lightweight installer focused on getting the OpenClaw AI agent runtime up and running fast. Spend less time on setup and more time on your agents.",
    ctaStart: "Install",
    ctaGithub: "GitHub",
    oneCommand: "Recommended command for this system",
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
    installLabel: "Install & Initialize",
    installTitle: "Choose the right install flow",
    installDesc:
      "The page detects your current platform and shows the matching command. You can also review the full Linux/macOS and Windows flows manually.",
    linuxLabel: "Linux / macOS",
    linuxTitle: "Shell install command",
    linuxDesc: "Use this in Linux or macOS terminal environments. After installation, continue with OpenClaw initialization.",
    windowsLabel: "Windows",
    windowsTitle: "PowerShell install command",
    windowsDesc: "Use this in Windows PowerShell. Restart the terminal after installation if needed, then initialize OpenClaw.",
    initLabel: "Initialize",
    initTitle: "How to initialize OpenClaw after install",
    initDesc: "Once installation succeeds, complete onboarding and health checks before connecting channels or configuring models.",
    initStep1Title: "1. Run the onboarding wizard",
    initStep1Desc: "Start with onboard to create local config and service state.",
    initStep2Title: "2. Verify runtime health",
    initStep2Desc: "Run doctor to confirm the environment, dependencies, and services are healthy.",
    initStep3Title: "3. Continue configuration",
    initStep3Desc: "Use configure, models, channels, and related commands for the rest of setup.",
    usageLabel: "Usage",
    usageTitle: "What the installer does",
    usageDesc: "ClawForge focuses on a smooth bootstrap path for OpenClaw AI agents.",
    step1: "Detects your platform and selects the right install flow.",
    step2: "Ensures Git and Node.js are available.",
    step3: "Installs the OpenClaw CLI.",
    step4: "Updates PATH and creates a command you can run directly.",
    step5: "Guides you into OpenClaw onboarding.",
    faqLabel: "FAQ",
    faqTitle: "Common questions",
    faq1Q: "What is ClawForge?",
    faq1A: "A lightweight installer focused on getting OpenClaw AI agents running quickly.",
    faq2Q: "Does it support Windows?",
    faq2A: "Yes. The page shows a PowerShell install command for Windows users.",
    faq3Q: "Is it open source?",
    faq3A: "Yes. The project is designed to be easy to inspect and extend.",
    faq4Q: "What should I do first after install?",
    faq4A: "Run openclaw onboard --install-daemon first, then openclaw doctor.",
    footerTagline: "One-command installer for OpenClaw AI agents",
    langLabel: "Language",
    langZh: "Chinese",
    langEn: "English",
    copy: "Copy",
    copied: "Copied",
    copySuccess: "Command copied to clipboard",
    copyFailed: "Copy failed. Please copy it manually.",
  },
};

const COMMANDS = {
  unixInstall: "curl -fsSL https://clawforge.com.cn/install.sh | bash",
  windowsInstall: "irm https://clawforge.com.cn/install.ps1 | iex",
  onboard: "openclaw onboard --install-daemon",
  doctor: "openclaw doctor",
  configure: "openclaw configure",
};

function detectPlatform() {
  if (typeof navigator === "undefined") return "unknown";

  const ua = navigator.userAgent || "";
  const platform = navigator.platform || "";
  const value = `${ua} ${platform}`.toLowerCase();

  if (value.includes("win")) return "windows";
  if (value.includes("mac") || value.includes("darwin")) return "unix";
  if (value.includes("linux") || value.includes("x11")) return "unix";
  return "unknown";
}

function copyText(text) {
  if (typeof navigator !== "undefined" && navigator.clipboard?.writeText) {
    return navigator.clipboard.writeText(text);
  }
  return Promise.reject(new Error("clipboard unavailable"));
}

function LangSelect({ lang, setLang, t }) {
  return (
    <select
      value={lang}
      onChange={(e) => setLang(e.target.value)}
      className="rounded-2xl border border-zinc-700 bg-zinc-900/80 px-4 py-2 text-sm text-white outline-none transition focus:border-blue-500"
      aria-label={t.langLabel}
    >
      <option value="zh">{t.langZh}</option>
      <option value="en">{t.langEn}</option>
    </select>
  );
}

function CommandCard({ label, title, desc, command, accent = "blue", copyLabel, copiedLabel, onCopy, copied }) {
  const accentClass = {
    blue: "text-blue-300",
    emerald: "text-emerald-300",
    violet: "text-violet-300",
  }[accent];

  return (
    <div className="rounded-[2rem] border border-zinc-800 bg-zinc-900 p-6 sm:p-8">
      <div className={`text-sm font-medium uppercase tracking-[0.2em] ${accentClass}`}>{label}</div>
      <div className="mt-4 flex items-start justify-between gap-4">
        <h3 className="text-3xl font-bold text-white">{title}</h3>
        <button
          onClick={onCopy}
          className="shrink-0 rounded-xl border border-zinc-700 px-3 py-2 text-xs font-medium text-zinc-200 transition hover:border-zinc-500 hover:bg-zinc-800"
        >
          {copied ? copiedLabel : copyLabel}
        </button>
      </div>
      <p className="mt-4 text-zinc-400">{desc}</p>
      <div className="mt-6 overflow-x-auto rounded-2xl bg-black p-4 font-mono text-sm text-zinc-100">
        {command}
      </div>
    </div>
  );
}

function Toast({ message, visible }) {
  return (
    <div
      className={`fixed bottom-5 left-1/2 z-50 -translate-x-1/2 rounded-2xl border border-zinc-700 bg-zinc-900/95 px-4 py-3 text-sm text-white shadow-2xl shadow-black/40 backdrop-blur transition-all ${
        visible ? "translate-y-0 opacity-100" : "pointer-events-none translate-y-3 opacity-0"
      }`}
    >
      {message}
    </div>
  );
}

export default function App() {
  const [lang, setLang] = useState("zh");
  const [platform, setPlatform] = useState("unknown");
  const [copiedKey, setCopiedKey] = useState("");
  const [toast, setToast] = useState({ visible: false, message: "" });
  const t = useMemo(() => translations[lang], [lang]);

  useEffect(() => {
    setPlatform(detectPlatform());
  }, []);

  useEffect(() => {
    if (!toast.visible) return;
    const timer = setTimeout(() => setToast({ visible: false, message: "" }), 1800);
    return () => clearTimeout(timer);
  }, [toast]);

  const detectedInstallCommand = platform === "windows" ? COMMANDS.windowsInstall : COMMANDS.unixInstall;

  const handleCopy = async (text, key) => {
    try {
      await copyText(text);
      setCopiedKey(key);
      setToast({ visible: true, message: t.copySuccess });
      setTimeout(() => setCopiedKey(""), 1800);
    } catch {
      setToast({ visible: true, message: t.copyFailed });
    }
  };

  return (
    <div className="min-h-screen bg-zinc-950 text-zinc-100">
      <Toast message={toast.message} visible={toast.visible} />

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
              <LangSelect lang={lang} setLang={setLang} t={t} />
            </div>
          </div>

          <div className="mt-12 lg:mt-16">
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
                <button
                  onClick={() => handleCopy(detectedInstallCommand, "hero")}
                  className="rounded-2xl bg-blue-500 px-5 py-3 text-center text-sm font-semibold text-white shadow-lg shadow-blue-950/40 transition hover:bg-blue-400"
                >
                  {copiedKey === "hero" ? t.copied : t.ctaStart}
                </button>
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
                  {detectedInstallCommand}
                </div>
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

        <section id="install" className="mt-24">
          <div className="max-w-3xl">
            <div className="text-sm font-medium uppercase tracking-[0.2em] text-blue-300">{t.installLabel}</div>
            <h2 className="mt-4 text-3xl font-bold tracking-tight text-white sm:text-4xl">{t.installTitle}</h2>
            <p className="mt-4 text-zinc-400">{t.installDesc}</p>
          </div>

          <div className="mt-10 grid gap-8 lg:grid-cols-2">
            <CommandCard
              label={t.linuxLabel}
              title={t.linuxTitle}
              desc={t.linuxDesc}
              command={COMMANDS.unixInstall}
              accent="emerald"
              copyLabel={t.copy}
              copiedLabel={t.copied}
              onCopy={() => handleCopy(COMMANDS.unixInstall, "unix")}
              copied={copiedKey === "unix"}
            />
            <CommandCard
              label={t.windowsLabel}
              title={t.windowsTitle}
              desc={t.windowsDesc}
              command={COMMANDS.windowsInstall}
              accent="violet"
              copyLabel={t.copy}
              copiedLabel={t.copied}
              onCopy={() => handleCopy(COMMANDS.windowsInstall, "win")}
              copied={copiedKey === "win"}
            />
          </div>

          <div className="mt-8 rounded-[2rem] border border-zinc-800 bg-zinc-900 p-6 sm:p-8">
            <div className="text-sm font-medium uppercase tracking-[0.2em] text-amber-300">{t.initLabel}</div>
            <h3 className="mt-4 text-3xl font-bold text-white">{t.initTitle}</h3>
            <p className="mt-4 text-zinc-400">{t.initDesc}</p>

            <div className="mt-8 grid gap-6 md:grid-cols-2 xl:grid-cols-3">
              <div className="rounded-3xl border border-zinc-800 bg-black/40 p-5">
                <div className="text-base font-semibold text-white">{t.initStep1Title}</div>
                <p className="mt-3 text-sm leading-7 text-zinc-400">{t.initStep1Desc}</p>
                <div className="mt-4 overflow-x-auto rounded-2xl bg-black p-4 font-mono text-sm text-emerald-300">
                  {COMMANDS.onboard}
                </div>
              </div>
              <div className="rounded-3xl border border-zinc-800 bg-black/40 p-5">
                <div className="text-base font-semibold text-white">{t.initStep2Title}</div>
                <p className="mt-3 text-sm leading-7 text-zinc-400">{t.initStep2Desc}</p>
                <div className="mt-4 overflow-x-auto rounded-2xl bg-black p-4 font-mono text-sm text-emerald-300">
                  {COMMANDS.doctor}
                </div>
              </div>
              <div className="rounded-3xl border border-zinc-800 bg-black/40 p-5 md:col-span-2 xl:col-span-1">
                <div className="text-base font-semibold text-white">{t.initStep3Title}</div>
                <p className="mt-3 text-sm leading-7 text-zinc-400">{t.initStep3Desc}</p>
                <div className="mt-4 overflow-x-auto rounded-2xl bg-black p-4 font-mono text-sm text-emerald-300">
                  {COMMANDS.configure}
                </div>
              </div>
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
            <a href="https://github.com/zhaodingmao/ClawForge" className="hover:text-white">GitHub</a>
          </div>
        </div>
        <div className="border-t border-zinc-800 px-4 py-4 text-center text-xs text-zinc-500 sm:px-6 lg:px-8">
          备案信息预留位置
        </div>
      </footer>
    </div>
  );
}
