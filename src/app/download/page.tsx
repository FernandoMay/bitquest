"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { 
  Download, 
  Smartphone, 
  Monitor, 
  Tablet,
  CheckCircle2,
  Github,
  Chrome,
  ArrowRight,
  Shield,
  Zap,
  Star,
  Users
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";

export default function DownloadPage() {
  const [selectedPlatform, setSelectedPlatform] = useState("android");

  const platforms = [
    {
      id: "android",
      name: "Android",
      icon: Smartphone,
      description: "Disponible para Android 8.0+",
      version: "v1.0.0",
      size: "45 MB",
      downloads: "2.5K+",
      features: [
        "Misiones interactivas",
        "AI Tutor integrado", 
        "Minijuegos educativos",
        "Progreso offline"
      ]
    },
    {
      id: "web",
      name: "Web",
      icon: Monitor,
      description: "Juega directamente en tu navegador",
      version: "v1.0.0",
      size: "Sin descarga",
      downloads: "5K+",
      features: [
        "Acceso instantáneo",
        "Sin instalación",
        "Multiplataforma",
        "Siempre actualizado"
      ]
    },
    {
      id: "ios",
      name: "iOS",
      icon: Tablet,
      description: "Próximamente en App Store",
      version: "Pronto",
      size: "~50 MB",
      downloads: "Próximamente",
      features: [
        "Optimizado para iPhone/iPad",
        "Sincronización con iCloud",
        "Notificaciones push",
        "Modo oscuro"
      ],
      disabled: true
    }
  ];

  const handleDownload = (platform: string) => {
    if (platform === "android") {
      // Descargar APK directamente desde public/apk/
      window.open("/apk/bitquest-latest.apk", "_blank");
    } else if (platform === "web") {
      // Redirigir al juego web
      window.open("/play", "_blank");
    } else if (platform === "ios") {
      // Redirigir a la página de espera de iOS
      window.open("#espera-ios", "_self");
    }
  };

  return (
    <main className="flex-1">
      {/* Hero Section */}
      <section className="relative min-h-screen flex items-center justify-center overflow-hidden bg-mesh-gradient">
        <div className="container mx-auto px-4 py-20 relative z-10">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
            className="text-center space-y-8 max-w-4xl mx-auto"
          >
            <Badge variant="outline" className="border-primary text-primary px-4 py-2 text-sm">
              <Download className="w-4 h-4 mr-2" />
              Descargar BITQUEST
            </Badge>
            
            <h1 className="text-5xl md:text-7xl font-bold leading-tight">
              <span className="text-gradient-bitcoin">BITQUEST</span>
              <br />
              <span className="text-foreground">Para Todos</span>
            </h1>
            
            <p className="text-xl md:text-2xl text-muted-foreground">
              Aprende Bitcoin jugando en tu dispositivo favorito
            </p>
            
            <p className="text-lg text-muted-foreground">
              Disponible para Android y Web. Próximamente en iOS.
            </p>

            {/* Stats */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mt-12">
              {[
                { label: "Descargas", value: "7.5K+", icon: Download },
                { label: "Usuarios Activos", value: "2.5K+", icon: Users },
                { label: "Calificación", value: "4.8/5", icon: Star },
                { label: "Países", value: "15+", icon: Shield }
              ].map((stat, index) => (
                <motion.div
                  key={stat.label}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.1 }}
                  className="text-center"
                >
                  <stat.icon className="w-6 h-6 mx-auto mb-2 text-primary" />
                  <p className="text-2xl font-bold text-foreground">{stat.value}</p>
                  <p className="text-sm text-muted-foreground">{stat.label}</p>
                </motion.div>
              ))}
            </div>
          </motion.div>
        </div>
      </section>

      {/* Download Options */}
      <section className="py-20 bg-background">
        <div className="container mx-auto px-4">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-16"
          >
            <h2 className="text-4xl md:text-5xl font-bold mb-4">
              Elige tu <span className="text-gradient-bitcoin">Plataforma</span>
            </h2>
            <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
              BITQUEST está disponible en múltiples plataformas para que aprendas donde y cuando quieras
            </p>
          </motion.div>

          <div className="grid md:grid-cols-3 gap-8">
            {platforms.map((platform, index) => (
              <motion.div
                key={platform.id}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.1 }}
                viewport={{ once: true }}
              >
                <Card className={`h-full card-hover ${platform.disabled ? 'opacity-60' : 'glass-card'} group`}>
                  <CardHeader className="text-center">
                    <div className="w-20 h-20 rounded-full bg-primary/20 flex items-center justify-center mx-auto mb-4">
                      <platform.icon className="w-10 h-10 text-primary" />
                    </div>
                    <CardTitle className="text-2xl">{platform.name}</CardTitle>
                    <CardDescription>{platform.description}</CardDescription>
                    
                    <div className="flex justify-center gap-4 mt-4">
                      <Badge variant="outline">{platform.version}</Badge>
                      <Badge variant="outline">{platform.size}</Badge>
                    </div>
                  </CardHeader>
                  
                  <CardContent className="space-y-6">
                    {/* Features */}
                    <div className="space-y-3">
                      {platform.features.map((feature, i) => (
                        <div key={i} className="flex items-center gap-2">
                          <CheckCircle2 className="w-4 h-4 text-green-500 flex-shrink-0" />
                          <span className="text-sm">{feature}</span>
                        </div>
                      ))}
                    </div>

                    {/* Download Button */}
                    <Button 
                      size="lg" 
                      className="w-full"
                      disabled={platform.disabled}
                      onClick={() => handleDownload(platform.id)}
                    >
                      {platform.disabled ? (
                        <>
                          <Shield className="w-5 h-5 mr-2" />
                          Próximamente
                        </>
                      ) : (
                        <>
                          {platform.id === "android" && <Download className="w-5 h-5 mr-2" />}
                          {platform.id === "web" && <Chrome className="w-5 h-5 mr-2" />}
                          {platform.id === "ios" && <Download className="w-5 h-5 mr-2" />}
                          {platform.id === "android" && "Descargar APK"}
                          {platform.id === "web" && "Jugar Ahora"}
                          {platform.id === "ios" && "Notificarme"}
                        </>
                      )}
                    </Button>

                    {/* Downloads count */}
                    <div className="text-center text-sm text-muted-foreground">
                      <span className="font-semibold">{platform.downloads}</span> descargas
                    </div>
                  </CardContent>
                </Card>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 bg-card/30">
        <div className="container mx-auto px-4">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-16"
          >
            <h2 className="text-4xl md:text-5xl font-bold mb-4">
              Características <span className="text-gradient-bitcoin">Principales</span>
            </h2>
            <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
              Todo lo que necesitas para aprender Bitcoin de forma divertida
            </p>
          </motion.div>

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {[
              {
                icon: Zap,
                title: "Aprendizaje Gamificado",
                description: "Misiones, niveles y recompensas que hacen aprender Bitcoin addictive y divertido"
              },
              {
                icon: Shield,
                title: "100% Seguro",
                description: "Tus datos y progreso están protegidos con encriptación de nivel bancario"
              },
              {
                icon: Users,
                title: "Comunidad Activa",
                description: "Únete a miles de usuarios aprendiendo Bitcoin en toda Latinoamérica"
              },
              {
                icon: Star,
                title: "AI Tutor",
                description: "Tu guía personal de Bitcoin disponible 24/7 para responder tus dudas"
              },
              {
                icon: Monitor,
                title: "Modo Offline",
                description: "Aprende sin conexión a internet. Perfecto para viajar o zonas con mala señal"
              },
              {
                icon: Download,
                title: "Actualizaciones Gratuitas",
                description: "Recibe nuevas misiones, minijuegos y contenido sin costo adicional"
              }
            ].map((feature, index) => (
              <motion.div
                key={feature.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.1 }}
                viewport={{ once: true }}
              >
                <Card className="h-full glass-card">
                  <CardHeader>
                    <div className="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center mb-4">
                      <feature.icon className="w-6 h-6 text-primary" />
                    </div>
                    <CardTitle>{feature.title}</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <CardDescription>{feature.description}</CardDescription>
                  </CardContent>
                </Card>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-background">
        <div className="container mx-auto px-4">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center space-y-8"
          >
            <h2 className="text-4xl md:text-5xl font-bold">
              ¿Listo para <span className="text-gradient-bitcoin">Aprender?</span>
            </h2>
          </motion.div>
        </div>
      </section>
    </main>
  );
}
