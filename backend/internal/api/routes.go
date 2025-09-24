package api

import (
	"github.com/gin-gonic/gin"
	"qa-toolbox-backend/internal/middleware"
	"qa-toolbox-backend/internal/services"
)

func SetupRoutes(router *gin.Engine, services *services.Services, jwtSecret string) {
	// API版本组
	v1 := router.Group("/api/v1")
	{
		// 公开路由
		public := v1.Group("/")
		{
			// 认证相关
			authHandler := NewAuthHandler(services.AuthService)
			public.POST("/auth/register", authHandler.Register)
			public.POST("/auth/login", authHandler.Login)
			public.POST("/auth/forgot-password", authHandler.ForgotPassword)
			public.POST("/auth/reset-password", authHandler.ResetPassword)
			
			// 应用信息
			appHandler := NewAppHandler(services.AppService)
			public.GET("/apps", appHandler.GetApps)
			public.GET("/apps/:id", appHandler.GetAppByID)
			
			// 健康检查
			healthHandler := NewHealthHandler()
			public.GET("/health", healthHandler.Check)
			
			// AI服务（公开访问，但需要API密钥）
			aiHandler := NewAIHandler(services)
			aiHandler.RegisterRoutes(public)
			
			// 第三方服务（公开访问，但需要API密钥）
			thirdPartyHandler := NewThirdPartyHandler(services)
			thirdPartyHandler.RegisterRoutes(public)
		}

		// 需要认证的路由
		protected := v1.Group("/")
		protected.Use(middleware.AuthMiddleware(jwtSecret))
		{
			// 用户相关
			userHandler := NewUserHandler(services.AuthService)
			protected.GET("/user/profile", userHandler.GetProfile)
			protected.PUT("/user/profile", userHandler.UpdateProfile)
			protected.POST("/user/change-password", userHandler.ChangePassword)
			protected.POST("/user/logout", userHandler.Logout)
			
			// 会员相关
			membershipHandler := NewMembershipHandler(services.MembershipService)
			protected.GET("/membership/plans", membershipHandler.GetPlans)
			protected.POST("/membership/subscribe", membershipHandler.Subscribe)
			protected.GET("/membership/status", membershipHandler.GetStatus)
			protected.POST("/membership/cancel", membershipHandler.CancelSubscription)
			
			// 支付相关
			paymentHandler := NewPaymentHandler(services.PaymentService)
			protected.POST("/payment/create-intent", paymentHandler.CreatePaymentIntent)
			protected.POST("/payment/webhook", paymentHandler.HandleWebhook)
			protected.GET("/payment/history", paymentHandler.GetPaymentHistory)
			
			// 应用相关
			appHandler := NewAppHandler(services.AppService)
			protected.POST("/apps/:id/install", appHandler.InstallApp)
			protected.DELETE("/apps/:id/uninstall", appHandler.UninstallApp)
			protected.GET("/apps/installed", appHandler.GetInstalledApps)
			
			// QAToolBox Pro功能
			qaToolboxHandler := NewQAToolBoxHandler(services.QAToolBoxService)
			qaToolbox := protected.Group("/qa-toolbox")
			{
				qaToolbox.POST("/test-generation", qaToolboxHandler.GenerateTestCases)
				qaToolbox.GET("/test-cases", qaToolboxHandler.GetTestCases)
				qaToolbox.POST("/pdf-conversion", qaToolboxHandler.ConvertPDF)
				qaToolbox.GET("/pdf-conversions", qaToolboxHandler.GetPDFConversions)
				qaToolbox.POST("/crawler", qaToolboxHandler.CreateCrawlerTask)
				qaToolbox.GET("/crawler-tasks", qaToolboxHandler.GetCrawlerTasks)
				qaToolbox.POST("/api-test", qaToolboxHandler.RunAPITest)
				qaToolbox.GET("/api-tests", qaToolboxHandler.GetAPITests)
			}
			
			// LifeMode功能
			lifeModeHandler := NewLifeModeHandler(services.LifeModeService)
			lifeMode := protected.Group("/life-mode")
			{
				lifeMode.POST("/food-recommendation", lifeModeHandler.GetFoodRecommendation)
				lifeMode.POST("/travel-plan", lifeModeHandler.CreateTravelPlan)
				lifeMode.POST("/mood-entry", lifeModeHandler.CreateMoodEntry)
				lifeMode.GET("/mood-history", lifeModeHandler.GetMoodHistory)
				lifeMode.POST("/meditation-session", lifeModeHandler.StartMeditationSession)
				lifeMode.GET("/meditation-history", lifeModeHandler.GetMeditationHistory)
			}
			
			// FitTracker功能
			fitTrackerHandler := NewFitTrackerHandler(services.FitTrackerService)
			fitTracker := protected.Group("/fit-tracker")
			{
				fitTracker.POST("/workout", fitTrackerHandler.CreateWorkout)
				fitTracker.GET("/workouts", fitTrackerHandler.GetWorkouts)
				fitTracker.POST("/nutrition-log", fitTrackerHandler.LogNutrition)
				fitTracker.GET("/nutrition-history", fitTrackerHandler.GetNutritionHistory)
				fitTracker.POST("/health-metric", fitTrackerHandler.LogHealthMetric)
				fitTracker.GET("/health-metrics", fitTrackerHandler.GetHealthMetrics)
				fitTracker.POST("/habit-checkin", fitTrackerHandler.CheckInHabit)
				fitTracker.GET("/habits", fitTrackerHandler.GetHabits)
			}
			
			// SocialHub功能
			socialHubHandler := NewSocialHubHandler(services.SocialHubService)
			socialHub := protected.Group("/social-hub")
			{
				socialHub.POST("/match", socialHubHandler.FindMatches)
				socialHub.GET("/matches", socialHubHandler.GetMatches)
				socialHub.POST("/activity", socialHubHandler.CreateActivity)
				socialHub.GET("/activities", socialHubHandler.GetActivities)
				socialHub.POST("/activity/:id/join", socialHubHandler.JoinActivity)
				socialHub.POST("/chat/send", socialHubHandler.SendMessage)
				socialHub.GET("/chat/:id/messages", socialHubHandler.GetMessages)
			}
			
			// CreativeStudio功能
			creativeStudioHandler := NewCreativeStudioHandler(services.CreativeStudioService)
			creativeStudio := protected.Group("/creative-studio")
			{
				creativeStudio.POST("/ai-writing", creativeStudioHandler.GenerateContent)
				creativeStudio.GET("/writing-history", creativeStudioHandler.GetWritingHistory)
				creativeStudio.POST("/avatar-generation", creativeStudioHandler.GenerateAvatar)
				creativeStudio.GET("/avatars", creativeStudioHandler.GetAvatars)
				creativeStudio.POST("/music-composition", creativeStudioHandler.ComposeMusic)
				creativeStudio.GET("/music-compositions", creativeStudioHandler.GetMusicCompositions)
				creativeStudio.POST("/design", creativeStudioHandler.CreateDesign)
				creativeStudio.GET("/designs", creativeStudioHandler.GetDesigns)
			}
		}
	}
}