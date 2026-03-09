"use client";

import { useState, useEffect, useRef } from "react";
import { motion, useInView, AnimatePresence } from "framer-motion";
import { 
  Bitcoin, 
  Zap, 
  Trophy, 
  Target, 
  Coins, 
  TrendingUp, 
  Shield, 
  Wallet,
  MessageCircle,
  Play,
  ChevronRight,
  Star,
  Lock,
  Unlock,
  Sparkles,
  Globe,
  Users,
  Clock,
  ArrowRight,
  Download,
  Github,
  Twitter,
  MessageSquare,
  CheckCircle2,
  AlertCircle,
  Lightbulb,
  Gamepad2,
  Brain,
  BarChart3,
  Send
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import Image from "next/image";

// Bitcoin price API response type
interface BitcoinPrice {
  btc_mxn: number;
  btc_usd: number;
  change_24h: number;
  timestamp: string;
}

// Mission data
const missions = [
  {
    id: 1,
    world: "Mundo 1",
    title: "Dinero",
    description: "Descubre qué es el dinero y por qué existe",
    icon: Coins,
    color: "#F7931A",
    levels: ["¿Qué es el dinero?", "Funciones del dinero", "Dinero fiat vs digital"],
    xp: 200,
    unlocked: true,
  },
  {
    id: 2,
    world: "Mundo 2",
    title: "Inflación",
    description: "Entiende cómo la inflación afecta tus ahorros",
    icon: TrendingUp,
    color: "#EF4444",
    levels: ["¿Qué es la inflación?", "Inflación en México", "Bitcoin como refugio"],
    xp: 250,
    unlocked: true,
  },
  {
    id: 3,
    world: "Mundo 3",
    title: "Blockchain",
    description: "Aprende la tecnología detrás de Bitcoin",
    icon: Shield,
    color: "#3B82F6",
    levels: ["¿Qué es blockchain?", "Bloques y hashes", "Descentralización"],
    xp: 300,
    unlocked: true,
  },
  {
    id: 4,
    world: "Mundo 4",
    title: "Minería",
    description: "Descubre cómo se crean nuevos bitcoins",
    icon: Bitcoin,
    color: "#22C55E",
    levels: ["Proof of Work", "Mineros y nodos", "Halving"],
    xp: 350,
    unlocked: false,
  },
  {
    id: 5,
    world: "Mundo 5",
    title: "Wallets",
    description: "Aprende a guardar Bitcoin de forma segura",
    icon: Wallet,
    color: "#9333EA",
    levels: ["Tipos de wallets", "Claves privadas", "Autocustodia"],
    xp: 400,
    unlocked: false,
  },
  {
    id: 6,
    world: "Mundo 6",
    title: "Lightning",
    description: "Pagos instantáneos con Lightning Network",
    icon: Zap,
    color: "#06B6D4",
    levels: ["¿Qué es Lightning?", "Canales de pago", "Remesas con BTC"],
    xp: 500,
    unlocked: false,
  },
];

// Minigames data
const minigames = [
  {
    title: "Build a Block",
    description: "Construye un bloque válido arrastrando los elementos correctos",
    icon: "🧱",
    difficulty: "Medio",
    xp: 100,
  },
  {
    title: "Mine the Hash",
    description: "Encuentra el hash correcto antes de que se acabe el tiempo",
    icon: "⛏️",
    difficulty: "Difícil",
    xp: 150,
  },
  {
    title: "Inflation Simulator",
    description: "Ve cómo tu dinero pierde valor con el tiempo",
    icon: "📉",
    difficulty: "Fácil",
    xp: 75,
  },
  {
    title: "Lightning Race",
    description: "Compite enviando pagos por Lightning Network",
    icon: "⚡",
    difficulty: "Medio",
    xp: 120,
  },
];

// Stats data
const stats = [
  { label: "Usuarios Activos", value: "12,500+", icon: Users },
  { label: "Lecciones Completadas", value: "85,000+", icon: CheckCircle2 },
  { label: "Sats Ganados", value: "2.5M", icon: Bitcoin },
  { label: "Calificación", value: "4.9/5", icon: Star },
];

export default function BitQuestLanding() {
  const [bitcoinPrice, setBitcoinPrice] = useState<BitcoinPrice | null>(null);
  const [loading, setLoading] = useState(true);
  const [chatMessages, setChatMessages] = useState<Array<{role: string; content: string}>>([]);
  const [chatInput, setChatInput] = useState("");
  const [isTyping, setIsTyping] = useState(false);

  // Fetch Bitcoin price
  useEffect(() => {
    const fetchPrice = async () => {
      try {
        const res = await fetch("/api/bitcoin/price");
        const data = await res.json();
        setBitcoinPrice(data);
      } catch (error) {
        // Set mock data if API fails
        setBitcoinPrice({
          btc_mxn: 1245678.90,
          btc_usd: 72345.67,
          change_24h: 2.34,
          timestamp: new Date().toISOString(),
        });
      } finally {
        setLoading(false);
      }
    };
    fetchPrice();
    const interval = setInterval(fetchPrice, 30000);
    return () => clearInterval(interval);
  }, []);

  const handleSendMessage = async () => {
    if (!chatInput.trim()) return;
    
    const userMessage = chatInput;
    setChatInput("");
    setChatMessages(prev => [...prev, { role: "user", content: userMessage }]);
    setIsTyping(true);

    try {
      const res = await fetch("/api/ai/tutor", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ message: userMessage }),
      });
      const data = await res.json();
      setChatMessages(prev => [...prev, { role: "assistant", content: data.response }]);
    } catch {
      setChatMessages(prev => [...prev, { 
        role: "assistant", 
        content: "¡Hola! Soy Satoshi Mentor. Bitcoin es dinero digital descentralizado. ¿Te gustaría saber más sobre cómo funciona?" 
      }]);
    } finally {
      setIsTyping(false);
    }
  };

  return (
    <main className="flex-1">
      {/* Hero Section */}
      <section className="relative min-h-screen flex items-center justify-center overflow-hidden bg-mesh-gradient">
        {/* Floating Particles */}
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          {[...Array(20)].map((_, i) => (
            <motion.div
              key={i}
              className="absolute w-2 h-2 bg-primary/30 rounded-full"
              initial={{ 
                x: Math.random() * (typeof window !== 'undefined' ? window.innerWidth : 1000), 
                y: Math.random() * (typeof window !== 'undefined' ? window.innerHeight : 800),
                opacity: 0 
              }}
              animate={{ 
                y: [null, -100],
                opacity: [0, 1, 0]
              }}
              transition={{ 
                duration: 10 + Math.random() * 10,
                repeat: Infinity,
                delay: Math.random() * 5
              }}
            />
          ))}
        </div>

        <div className="container mx-auto px-4 py-20 relative z-10">
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            {/* Left Content */}
            <motion.div
              initial={{ opacity: 0, x: -50 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.8 }}
              className="space-y-8"
            >
              <Badge variant="outline" className="border-primary text-primary px-4 py-2 text-sm">
                <Sparkles className="w-4 h-4 mr-2" />
                Educación Financiera Gamificada
              </Badge>
              
              <h1 className="text-5xl md:text-7xl font-bold leading-tight">
                <span className="text-foreground">BIT</span>
                <span className="text-gradient-bitcoin">QUEST</span>
              </h1>
              
              <p className="text-2xl md:text-3xl text-muted-foreground">
                Aprende Bitcoin <span className="text-primary">jugando</span>
              </p>
              
              <p className="text-lg text-muted-foreground max-w-lg">
                Misiones, minijuegos y retos interactivos para dominar Bitcoin. 
                Desde conceptos básicos hasta Lightning Network.
              </p>

              {/* Live Bitcoin Price Card */}
              <Card className="glass-card max-w-md">
                <CardContent className="p-4">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center">
                        <Bitcoin className="w-6 h-6 text-primary" />
                      </div>
                      <div>
                        <p className="text-sm text-muted-foreground">BTC/MXN</p>
                        <p className="text-2xl font-bold text-foreground">
                          {loading ? (
                            <span className="animate-pulse">Cargando...</span>
                          ) : (
                            `$${bitcoinPrice?.btc_mxn.toLocaleString('es-MX', { maximumFractionDigits: 0 })}`
                          )}
                        </p>
                      </div>
                    </div>
                    <div className={`flex items-center gap-1 ${bitcoinPrice && bitcoinPrice.change_24h >= 0 ? 'text-green-500' : 'text-red-500'}`}>
                      {bitcoinPrice && bitcoinPrice.change_24h >= 0 ? (
                        <TrendingUp className="w-4 h-4" />
                      ) : (
                        <TrendingUp className="w-4 h-4 rotate-180" />
                      )}
                      <span className="font-semibold">
                        {bitcoinPrice?.change_24h ? `${bitcoinPrice.change_24h >= 0 ? '+' : ''}${bitcoinPrice.change_24h.toFixed(2)}%` : '0.00%'}
                      </span>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <div className="flex flex-wrap gap-4">
                <Button size="lg" className="bg-primary hover:bg-primary/90 text-primary-foreground px-8 py-6 text-lg font-semibold" asChild>
                  <a href="#jugar">
                    <Play className="w-5 h-5 mr-2" />
                    Comenzar Gratis
                  </a>
                </Button>
                <Button size="lg" variant="outline" className="border-primary/50 hover:bg-primary/10 px-8 py-6 text-lg" asChild>
                  <a href="/download">
                    <Download className="w-5 h-5 mr-2" />
                    Descargar App
                  </a>
                </Button>
              </div>
            </motion.div>

            {/* Right Content - Phone Mockup */}
            <motion.div
              initial={{ opacity: 0, x: 50 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.8, delay: 0.2 }}
              className="relative flex justify-center"
            >
              <div className="relative">
                {/* Glowing background */}
                <div className="absolute inset-0 bg-gradient-to-r from-primary/20 via-purple-500/20 to-primary/20 blur-3xl rounded-full scale-150" />
                
                {/* Phone frame */}
                <div className="relative bg-gradient-to-b from-gray-800 to-gray-900 rounded-[3rem] p-2 shadow-2xl">
                  <div className="bg-background rounded-[2.5rem] overflow-hidden w-72 h-[580px]">
                    {/* Status bar */}
                    <div className="bg-card px-6 py-2 flex justify-between items-center">
                      <span className="text-xs text-muted-foreground">9:41</span>
                      <div className="flex gap-1">
                        <div className="w-4 h-2 bg-muted-foreground rounded-sm" />
                        <div className="w-4 h-2 bg-primary rounded-sm" />
                      </div>
                    </div>
                    
                    {/* App content */}
                    <div className="p-4 space-y-4 bg-background">
                      {/* Header */}
                      <div className="flex items-center justify-between">
                        <div>
                          <p className="text-sm text-muted-foreground">Nivel actual</p>
                          <p className="font-bold text-primary">Aprendiz de Satoshi</p>
                        </div>
                        <div className="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center">
                          <Trophy className="w-6 h-6 text-primary" />
                        </div>
                      </div>
                      
                      {/* XP Progress */}
                      <div className="space-y-2">
                        <div className="flex justify-between text-sm">
                          <span className="text-muted-foreground">XP Total</span>
                          <span className="text-primary font-semibold">750 / 1000</span>
                        </div>
                        <Progress value={75} className="h-3" />
                      </div>

                      {/* Missions Preview */}
                      <div className="space-y-3 mt-4">
                        <p className="font-semibold text-foreground">Misiones Activas</p>
                        {missions.slice(0, 3).map((mission, index) => (
                          <motion.div
                            key={mission.id}
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ delay: index * 0.1 }}
                            className={`p-3 rounded-xl ${mission.unlocked ? 'bg-card' : 'bg-card/50'} border border-border/50`}
                          >
                            <div className="flex items-center gap-3">
                              <div 
                                className="w-10 h-10 rounded-lg flex items-center justify-center"
                                style={{ backgroundColor: `${mission.color}20` }}
                              >
                                <mission.icon className="w-5 h-5" style={{ color: mission.color }} />
                              </div>
                              <div className="flex-1">
                                <p className="font-medium text-foreground text-sm">{mission.title}</p>
                                <p className="text-xs text-muted-foreground">+{mission.xp} XP</p>
                              </div>
                              {mission.unlocked ? (
                                <Unlock className="w-4 h-4 text-primary" />
                              ) : (
                                <Lock className="w-4 h-4 text-muted-foreground" />
                              )}
                            </div>
                          </motion.div>
                        ))}
                      </div>

                      {/* Quick Actions */}
                      <div className="grid grid-cols-2 gap-2 mt-4">
                        <Button variant="outline" className="h-16 border-primary/30 bg-primary/5" asChild>
                          <a href="/play">
                            <Gamepad2 className="w-5 h-5 mr-2 text-primary" />
                            <span className="text-xs">Jugar</span>
                          </a>
                        </Button>
                        <Button variant="outline" className="h-16 border-purple-500/30 bg-purple-500/5">
                          <Brain className="w-5 h-5 mr-2 text-purple-500" />
                          <span className="text-xs">AI Tutor</span>
                        </Button>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Floating elements */}
                <motion.div
                  animate={{ y: [0, -10, 0] }}
                  transition={{ duration: 3, repeat: Infinity }}
                  className="absolute -top-4 -right-4 bg-card rounded-xl p-3 shadow-xl border border-primary/30"
                >
                  <div className="flex items-center gap-2">
                    <Zap className="w-5 h-5 text-primary" />
                    <span className="font-semibold text-sm">+100 XP</span>
                  </div>
                </motion.div>

                <motion.div
                  animate={{ y: [0, 10, 0] }}
                  transition={{ duration: 4, repeat: Infinity }}
                  className="absolute -bottom-4 -left-4 bg-card rounded-xl p-3 shadow-xl border border-purple-500/30"
                >
                  <div className="flex items-center gap-2">
                    <Trophy className="w-5 h-5 text-purple-500" />
                    <span className="font-semibold text-sm">Logro nuevo</span>
                  </div>
                </motion.div>
              </div>
            </motion.div>
          </div>
        </div>

        {/* Scroll indicator */}
        <motion.div
          animate={{ y: [0, 10, 0] }}
          transition={{ duration: 2, repeat: Infinity }}
          className="absolute bottom-8 left-1/2 -translate-x-1/2"
        >
          <ChevronRight className="w-8 h-8 text-primary rotate-90" />
        </motion.div>
      </section>

      {/* Stats Section */}
      <section className="py-16 bg-card/50 border-y border-border">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
            {stats.map((stat, index) => (
              <motion.div
                key={stat.label}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.1 }}
                viewport={{ once: true }}
                className="text-center"
              >
                <stat.icon className="w-8 h-8 mx-auto mb-2 text-primary" />
                <p className="text-3xl font-bold text-foreground">{stat.value}</p>
                <p className="text-sm text-muted-foreground">{stat.label}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Missions Section */}
      <section className="py-20 bg-background">
        <div className="container mx-auto px-4">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-16"
          >
            <Badge variant="outline" className="border-primary text-primary mb-4">
              <Target className="w-4 h-4 mr-2" />
              Mapa de Aprendizaje
            </Badge>
            <h2 className="text-4xl md:text-5xl font-bold mb-4">
              Seis Mundos, <span className="text-gradient-bitcoin">Un Objetivo</span>
            </h2>
            <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
              Progresa desde los conceptos básicos del dinero hasta dominar Lightning Network
            </p>
          </motion.div>

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {missions.map((mission, index) => (
              <motion.div
                key={mission.id}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.1 }}
                viewport={{ once: true }}
              >
                <Card className={`h-full card-hover ${mission.unlocked ? 'glass-card' : 'opacity-60'} group`}>
                  <CardHeader>
                    <div className="flex items-center justify-between">
                      <Badge 
                        variant="outline" 
                        className="border-border"
                        style={{ borderColor: mission.color, color: mission.color }}
                      >
                        {mission.world}
                      </Badge>
                      {mission.unlocked ? (
                        <Unlock className="w-5 h-5 text-primary" />
                      ) : (
                        <Lock className="w-5 h-5 text-muted-foreground" />
                      )}
                    </div>
                    <CardTitle className="flex items-center gap-3 mt-2">
                      <div 
                        className="w-12 h-12 rounded-xl flex items-center justify-center"
                        style={{ backgroundColor: `${mission.color}20` }}
                      >
                        <mission.icon className="w-6 h-6" style={{ color: mission.color }} />
                      </div>
                      <span className="text-xl">{mission.title}</span>
                    </CardTitle>
                    <CardDescription className="mt-2">
                      {mission.description}
                    </CardDescription>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-2">
                      {mission.levels.map((level, i) => (
                        <div key={i} className="flex items-center gap-2 text-sm text-muted-foreground">
                          <div 
                            className="w-6 h-6 rounded-full flex items-center justify-center text-xs font-semibold"
                            style={{ backgroundColor: `${mission.color}20`, color: mission.color }}
                          >
                            {i + 1}
                          </div>
                          {level}
                        </div>
                      ))}
                    </div>
                    <div className="flex items-center justify-between mt-4 pt-4 border-t border-border">
                      <span className="text-sm text-muted-foreground">Recompensa</span>
                      <Badge className="bg-primary/20 text-primary hover:bg-primary/30">
                        +{mission.xp} XP
                      </Badge>
                    </div>
                  </CardContent>
                </Card>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Minigames Section */}
      <section id="jugar" className="py-20 bg-card/30">
        <div className="container mx-auto px-4">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-16"
          >
            <Badge variant="outline" className="border-purple-500 text-purple-500 mb-4">
              <Gamepad2 className="w-4 h-4 mr-2" />
              Mini-Juegos
            </Badge>
            <h2 className="text-4xl md:text-5xl font-bold mb-4">
              Aprende <span className="text-gradient-lightning">Haciendo</span>
            </h2>
            <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
              Simulaciones interactivas que hacen que aprender Bitcoin sea divertido
            </p>
          </motion.div>

          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
            {minigames.map((game, index) => (
              <motion.div
                key={game.title}
                initial={{ opacity: 0, scale: 0.9 }}
                whileInView={{ opacity: 1, scale: 1 }}
                transition={{ delay: index * 0.1 }}
                viewport={{ once: true }}
                whileHover={{ scale: 1.05 }}
                className="group cursor-pointer"
              >
                <Card className="h-full glass-card overflow-hidden">
                  <div className="h-32 bg-gradient-to-br from-primary/20 to-purple-500/20 flex items-center justify-center text-5xl">
                    {game.icon}
                  </div>
                  <CardContent className="p-4">
                    <h3 className="font-bold text-lg mb-1">{game.title}</h3>
                    <p className="text-sm text-muted-foreground mb-3">{game.description}</p>
                    <div className="flex items-center justify-between">
                      <Badge variant="outline" className="text-xs">
                        {game.difficulty}
                      </Badge>
                      <Badge className="bg-primary/20 text-primary text-xs">
                        +{game.xp} XP
                      </Badge>
                    </div>
                  </CardContent>
                </Card>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* AI Tutor Section */}
      <section className="py-20 bg-background">
        <div className="container mx-auto px-4">
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            <motion.div
              initial={{ opacity: 0, x: -30 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              className="space-y-6"
            >
              <Badge variant="outline" className="border-purple-500 text-purple-500">
                <Brain className="w-4 h-4 mr-2" />
                AI Tutor
              </Badge>
              <h2 className="text-4xl md:text-5xl font-bold">
                Pregunta a <span className="text-gradient-lightning">Satoshi Mentor</span>
              </h2>
              <p className="text-xl text-muted-foreground">
                Tu guía personal de Bitcoin. Pregunta lo que quieras y recibe explicaciones claras, 
                ejemplos de México y mini-quizzes para reforzar tu aprendizaje.
              </p>
              
              <div className="space-y-4">
                <div className="flex items-start gap-3">
                  <div className="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center flex-shrink-0">
                    <Lightbulb className="w-5 h-5 text-primary" />
                  </div>
                  <div>
                    <h4 className="font-semibold">Explicaciones claras</h4>
                    <p className="text-sm text-muted-foreground">Conceptos complejos explicados de forma simple</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <div className="w-10 h-10 rounded-full bg-purple-500/20 flex items-center justify-center flex-shrink-0">
                    <Globe className="w-5 h-5 text-purple-500" />
                  </div>
                  <div>
                    <h4 className="font-semibold">Contexto México</h4>
                    <p className="text-sm text-muted-foreground">Ejemplos con inflación MXN, remesas y más</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <div className="w-10 h-10 rounded-full bg-green-500/20 flex items-center justify-center flex-shrink-0">
                    <CheckCircle2 className="w-5 h-5 text-green-500" />
                  </div>
                  <div>
                    <h4 className="font-semibold">Quizzes interactivos</h4>
                    <p className="text-sm text-muted-foreground">Refuerza lo aprendido con preguntas</p>
                  </div>
                </div>
              </div>
            </motion.div>

            {/* Chat Demo */}
            <motion.div
              initial={{ opacity: 0, x: 30 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
            >
              <Card className="glass-card overflow-hidden">
                <CardHeader className="border-b border-border">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary to-purple-500 flex items-center justify-center">
                      <Brain className="w-5 h-5 text-white" />
                    </div>
                    <div>
                      <CardTitle className="text-lg">Satoshi Mentor</CardTitle>
                      <CardDescription>Tu guía de Bitcoin</CardDescription>
                    </div>
                    <Badge variant="outline" className="ml-auto border-green-500 text-green-500">
                      <span className="w-2 h-2 rounded-full bg-green-500 mr-2" />
                      En línea
                    </Badge>
                  </div>
                </CardHeader>
                <CardContent className="p-4">
                  <div className="h-64 overflow-y-auto space-y-4 mb-4">
                    {/* Initial message */}
                    <div className="flex gap-3">
                      <div className="w-8 h-8 rounded-full bg-gradient-to-br from-primary to-purple-500 flex items-center justify-center flex-shrink-0">
                        <Brain className="w-4 h-4 text-white" />
                      </div>
                      <div className="bg-card rounded-2xl rounded-tl-none p-3 max-w-[80%]">
                        <p className="text-sm">
                          ¡Hola! Soy Satoshi Mentor. Estoy aquí para ayudarte a entender Bitcoin. 
                          ¿Qué te gustaría aprender hoy?
                        </p>
                      </div>
                    </div>

                    {/* User question */}
                    <div className="flex gap-3 justify-end">
                      <div className="bg-primary/20 rounded-2xl rounded-tr-none p-3 max-w-[80%]">
                        <p className="text-sm">¿Qué es el halving?</p>
                      </div>
                    </div>

                    {/* AI response */}
                    <div className="flex gap-3">
                      <div className="w-8 h-8 rounded-full bg-gradient-to-br from-primary to-purple-500 flex items-center justify-center flex-shrink-0">
                        <Brain className="w-4 h-4 text-white" />
                      </div>
                      <div className="bg-card rounded-2xl rounded-tl-none p-3 max-w-[80%]">
                        <p className="text-sm mb-2">
                          <strong>Explicación:</strong> El halving es un evento que ocurre cada 210,000 bloques 
                          (aprox. 4 años) donde la recompensa de los mineros se reduce a la mitad.
                        </p>
                        <p className="text-sm mb-2">
                          <strong>Ejemplo:</strong> En 2012, los mineros recibían 50 BTC por bloque. 
                          Hoy, reciben 3.125 BTC.
                        </p>
                        <p className="text-sm text-muted-foreground">
                          <strong>Quiz:</strong> ¿Cada cuántos bloques ocurre el halving?
                        </p>
                      </div>
                    </div>

                    {/* Chat messages from actual interaction */}
                    <AnimatePresence>
                      {chatMessages.map((msg, i) => (
                        <motion.div
                          key={i}
                          initial={{ opacity: 0, y: 10 }}
                          animate={{ opacity: 1, y: 0 }}
                          className={`flex gap-3 ${msg.role === 'user' ? 'justify-end' : ''}`}
                        >
                          {msg.role === 'assistant' && (
                            <div className="w-8 h-8 rounded-full bg-gradient-to-br from-primary to-purple-500 flex items-center justify-center flex-shrink-0">
                              <Brain className="w-4 h-4 text-white" />
                            </div>
                          )}
                          <div className={`rounded-2xl p-3 max-w-[80%] ${msg.role === 'user' ? 'bg-primary/20 rounded-tr-none' : 'bg-card rounded-tl-none'}`}>
                            <p className="text-sm">{msg.content}</p>
                          </div>
                        </motion.div>
                      ))}
                      {isTyping && (
                        <motion.div
                          initial={{ opacity: 0 }}
                          animate={{ opacity: 1 }}
                          className="flex gap-3"
                        >
                          <div className="w-8 h-8 rounded-full bg-gradient-to-br from-primary to-purple-500 flex items-center justify-center flex-shrink-0">
                            <Brain className="w-4 h-4 text-white" />
                          </div>
                          <div className="bg-card rounded-2xl rounded-tl-none p-3">
                            <p className="text-sm text-muted-foreground">Escribiendo...</p>
                          </div>
                        </motion.div>
                      )}
                    </AnimatePresence>
                  </div>
                  
                  <div className="flex gap-2">
                    <Input
                      placeholder="Pregunta sobre Bitcoin..."
                      value={chatInput}
                      onChange={(e) => setChatInput(e.target.value)}
                      onKeyPress={(e) => e.key === 'Enter' && handleSendMessage()}
                      className="bg-card border-border"
                    />
                    <Button onClick={handleSendMessage} size="icon" className="bg-primary hover:bg-primary/90">
                      <Send className="w-4 h-4" />
                    </Button>
                  </div>
                </CardContent>
              </Card>
            </motion.div>
          </div>
        </div>
      </section>

      {/* Mexico Section */}
      <section className="py-20 bg-card/30">
        <div className="container mx-auto px-4">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-16"
          >
            <Badge variant="outline" className="border-green-500 text-green-500 mb-4">
              <Globe className="w-4 h-4 mr-2" />
              Hecho para México
            </Badge>
            <h2 className="text-4xl md:text-5xl font-bold mb-4">
              Educación Financiera <span className="text-primary">Real</span>
            </h2>
            <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
              Ejemplos y casos de uso relevantes para la realidad mexicana
            </p>
          </motion.div>

          <div className="grid md:grid-cols-3 gap-8">
            {/* Inflation Comparison */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.1 }}
              viewport={{ once: true }}
            >
              <Card className="h-full glass-card">
                <CardHeader>
                  <div className="w-12 h-12 rounded-xl bg-red-500/20 flex items-center justify-center mb-4">
                    <TrendingUp className="w-6 h-6 text-red-500" />
                  </div>
                  <CardTitle>Inflación MXN vs BTC</CardTitle>
                  <CardDescription>
                    Compara cómo $1,000 pesos de 2015 valdrían hoy
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div>
                      <div className="flex justify-between text-sm mb-1">
                        <span>Pesos MXN</span>
                        <span className="text-red-500">-35%</span>
                      </div>
                      <Progress value={65} className="h-2 bg-muted [&>div]:bg-red-500" />
                      <p className="text-xs text-muted-foreground mt-1">$650 poder adquisitivo</p>
                    </div>
                    <div>
                      <div className="flex justify-between text-sm mb-1">
                        <span>Bitcoin</span>
                        <span className="text-green-500">+10,000%</span>
                      </div>
                      <Progress value={100} className="h-2 bg-muted [&>div]:bg-green-500" />
                      <p className="text-xs text-muted-foreground mt-1">$100,000+ valor actual</p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </motion.div>

            {/* Remittances */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 }}
              viewport={{ once: true }}
            >
              <Card className="h-full glass-card">
                <CardHeader>
                  <div className="w-12 h-12 rounded-xl bg-primary/20 flex items-center justify-center mb-4">
                    <Zap className="w-6 h-6 text-primary" />
                  </div>
                  <CardTitle>Remesas con Lightning</CardTitle>
                  <CardDescription>
                    Envía dinero de USA a México en segundos
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    <div className="flex items-center justify-between p-3 rounded-lg bg-red-500/10 border border-red-500/20">
                      <div>
                        <p className="font-semibold text-sm">Western Union</p>
                        <p className="text-xs text-muted-foreground">3-5 días</p>
                      </div>
                      <p className="font-bold text-red-500">~7% comisión</p>
                    </div>
                    <div className="flex items-center justify-between p-3 rounded-lg bg-green-500/10 border border-green-500/20">
                      <div>
                        <p className="font-semibold text-sm">Lightning Network</p>
                        <p className="text-xs text-muted-foreground">Instantáneo</p>
                      </div>
                      <p className="font-bold text-green-500">~0.1% comisión</p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </motion.div>

            {/* Financial Inclusion */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
              viewport={{ once: true }}
            >
              <Card className="h-full glass-card">
                <CardHeader>
                  <div className="w-12 h-12 rounded-xl bg-purple-500/20 flex items-center justify-center mb-4">
                    <Wallet className="w-6 h-6 text-purple-500" />
                  </div>
                  <CardTitle>Inclusión Financiera</CardTitle>
                  <CardDescription>
                    Bitcoin para los 37 millones sin banco
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    <div className="text-center py-4">
                      <p className="text-4xl font-bold text-primary">37M</p>
                      <p className="text-sm text-muted-foreground">Mexicanos sin cuenta bancaria</p>
                    </div>
                    <p className="text-sm text-muted-foreground text-center">
                      Bitcoin permite acceso financiero con solo un smartphone, 
                      sin necesidad de banco.
                    </p>
                  </div>
                </CardContent>
              </Card>
            </motion.div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-background relative overflow-hidden">
        <div className="absolute inset-0 bg-mesh-gradient opacity-50" />
        <div className="container mx-auto px-4 relative z-10">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center max-w-3xl mx-auto"
          >
            <h2 className="text-4xl md:text-5xl font-bold mb-6">
              Empieza tu <span className="text-gradient-bitcoin">Aventura Bitcoin</span>
            </h2>
            <p className="text-xl text-muted-foreground mb-8">
              Únete a miles de mexicanos aprendiendo sobre el futuro del dinero. 
              Gratis, divertido y en español.
            </p>
            <div className="flex flex-wrap justify-center gap-4">
              <Button size="lg" className="bg-primary hover:bg-primary/90 text-primary-foreground px-8 py-6 text-lg font-semibold">
                <Play className="w-5 h-5 mr-2" />
                Jugar Ahora
              </Button>
              <Button size="lg" variant="outline" className="border-border px-8 py-6 text-lg">
                <Download className="w-5 h-5 mr-2" />
                Descargar App
              </Button>
            </div>
          </motion.div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-8 bg-card border-t border-border mt-auto">
        <div className="container mx-auto px-4">
          <div className="flex flex-col md:flex-row items-center justify-between gap-4">
            <div className="flex items-center gap-2">
              <Bitcoin className="w-6 h-6 text-primary" />
              <span className="font-bold text-lg">BITQUEST</span>
            </div>
            <p className="text-sm text-muted-foreground">
              © 2025 BITQUEST. Educación financiera para México.
            </p>
            <div className="flex items-center gap-4">
              <a href="#" className="text-muted-foreground hover:text-primary transition-colors">
                <Twitter className="w-5 h-5" />
              </a>
              <a href="#" className="text-muted-foreground hover:text-primary transition-colors">
                <Github className="w-5 h-5" />
              </a>
              <a href="#" className="text-muted-foreground hover:text-primary transition-colors">
                <MessageSquare className="w-5 h-5" />
              </a>
            </div>
          </div>
        </div>
      </footer>
    </main>
  );
}
