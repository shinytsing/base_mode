package services

import (
	"qa-toolbox-backend/internal/database"
	"qa-toolbox-backend/internal/config"
)

type Services struct {
	DB           *database.DB
	Redis        *database.RedisClient
	Config       *config.Config
	
	// 核心服务
	AuthService       *AuthService
	AppService        *AppService
	MembershipService *MembershipService
	PaymentService    *PaymentService
	
	// AI和第三方服务
	AIClientManager        *AIClientManager
	ThirdPartyClientManager *ThirdPartyClientManager
	
	// 应用服务
	QAToolBoxService     *QAToolBoxService
	LifeModeService      *LifeModeService
	FitTrackerService    *FitTrackerService
	SocialHubService     *SocialHubService
	CreativeStudioService *CreativeStudioService
}

func NewServices(db *database.DB, redis *database.RedisClient, cfg *config.Config) *Services {
	return &Services{
		DB:           db,
		Redis:        redis,
		Config:       cfg,
		
		// 核心服务
		AuthService:       NewAuthService(db, redis, cfg.JWTSecret),
		AppService:        NewAppService(db),
		MembershipService: NewMembershipService(db),
		PaymentService:    NewPaymentService(db, redis),
		
		// AI和第三方服务
		AIClientManager:        NewAIClientManager(cfg),
		ThirdPartyClientManager: NewThirdPartyClientManager(cfg),
		
		// 应用服务
		QAToolBoxService:     NewQAToolBoxService(db),
		LifeModeService:      NewLifeModeService(db),
		FitTrackerService:    NewFitTrackerService(db),
		SocialHubService:     NewSocialHubService(db),
		CreativeStudioService: NewCreativeStudioService(db),
	}
}
