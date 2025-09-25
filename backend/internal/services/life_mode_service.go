package services

import (
	"fmt"
	"time"

	"qa-toolbox-backend/internal/database"
)

type LifeModeService struct {
	db *database.DB
}

func NewLifeModeService(db *database.DB) *LifeModeService {
	return &LifeModeService{
		db: db,
	}
}

// FoodRecommendationRequest 食物推荐请求
type FoodRecommendationRequest struct {
	UserID    string `json:"user_id"`
	Cuisine   string `json:"cuisine"`
	Budget    string `json:"budget"`
	MealTime  string `json:"meal_time"`
	Dietary   string `json:"dietary"`
	Location  string `json:"location"`
}

// FoodRecommendationResponse 食物推荐响应
type FoodRecommendationResponse struct {
	ID          string    `json:"id"`
	UserID      string    `json:"user_id"`
	Recommendations []FoodRecommendation `json:"recommendations"`
	CreatedAt   time.Time `json:"created_at"`
}

type FoodRecommendation struct {
	Name        string  `json:"name"`
	Description string  `json:"description"`
	Price       float64 `json:"price"`
	Rating      float64 `json:"rating"`
	ImageURL    string  `json:"image_url"`
	Location    string  `json:"location"`
	Tags        []string `json:"tags"`
}

// GetFoodRecommendation 获取食物推荐
func (s *LifeModeService) GetFoodRecommendation(req *FoodRecommendationRequest) (*FoodRecommendationResponse, error) {
	// 这里应该调用AI服务生成推荐
	recommendations := []FoodRecommendation{
		{
			Name:        "川菜馆",
			Description: "正宗川菜，麻辣鲜香",
			Price:       50.0,
			Rating:      4.5,
			ImageURL:    "https://example.com/sichuan.jpg",
			Location:    "市中心",
			Tags:        []string{"川菜", "麻辣", "家常菜"},
		},
		{
			Name:        "日式料理",
			Description: "新鲜寿司和刺身",
			Price:       120.0,
			Rating:      4.8,
			ImageURL:    "https://example.com/japanese.jpg",
			Location:    "商业区",
			Tags:        []string{"日料", "寿司", "刺身"},
		},
	}

	response := &FoodRecommendationResponse{
		ID:            generateUUID(),
		UserID:        req.UserID,
		Recommendations: recommendations,
		CreatedAt:     time.Now(),
	}

	// 保存推荐记录到mood_entries表（临时使用）
	_, err := s.db.Exec(`
		INSERT INTO mood_entries (id, user_id, mood_type, intensity, notes, created_at)
		VALUES ($1, $2, 'food_recommendation', 5, $3, NOW())
	`, response.ID, req.UserID, fmt.Sprintf("Cuisine: %s, Budget: %s, MealTime: %s", req.Cuisine, req.Budget, req.MealTime))
	if err != nil {
		return nil, fmt.Errorf("failed to save food recommendation: %w", err)
	}

	return response, nil
}

// TravelPlanRequest 旅行计划请求
type TravelPlanRequest struct {
	UserID      string `json:"user_id"`
	Destination string `json:"destination"`
	StartDate   string `json:"start_date"`
	EndDate     string `json:"end_date"`
	Budget      float64 `json:"budget"`
	Travelers   int    `json:"travelers"`
	Interests   []string `json:"interests"`
}

// TravelPlanResponse 旅行计划响应
type TravelPlanResponse struct {
	ID          string    `json:"id"`
	UserID      string    `json:"user_id"`
	Destination string    `json:"destination"`
	Plan        TravelPlan `json:"plan"`
	CreatedAt   time.Time `json:"created_at"`
}

type TravelPlan struct {
	Days        []DayPlan `json:"days"`
	TotalCost   float64   `json:"total_cost"`
	Highlights  []string  `json:"highlights"`
	Tips        []string  `json:"tips"`
}

type DayPlan struct {
	Day         int      `json:"day"`
	Date        string   `json:"date"`
	Activities  []string `json:"activities"`
	Meals       []string `json:"meals"`
	Accommodation string `json:"accommodation"`
	Cost        float64  `json:"cost"`
}

// CreateTravelPlan 创建旅行计划
func (s *LifeModeService) CreateTravelPlan(req *TravelPlanRequest) (*TravelPlanResponse, error) {
	// 这里应该调用AI服务生成旅行计划
	plan := TravelPlan{
		Days: []DayPlan{
			{
				Day:           1,
				Date:          req.StartDate,
				Activities:    []string{"到达目的地", "酒店入住", "市区游览"},
				Meals:         []string{"午餐", "晚餐"},
				Accommodation: "市中心酒店",
				Cost:          300.0,
			},
			{
				Day:           2,
				Date:          req.EndDate,
				Activities:    []string{"景点游览", "购物", "返程"},
				Meals:         []string{"早餐", "午餐"},
				Accommodation: "机场附近酒店",
				Cost:          250.0,
			},
		},
		TotalCost:  550.0,
		Highlights: []string{"著名景点", "当地美食", "文化体验"},
		Tips:       []string{"提前预订酒店", "注意天气变化", "准备现金"},
	}

	response := &TravelPlanResponse{
		ID:          generateUUID(),
		UserID:      req.UserID,
		Destination: req.Destination,
		Plan:        plan,
		CreatedAt:   time.Now(),
	}

	// 保存旅行计划到meditation_sessions表（临时使用）
	_, err := s.db.Exec(`
		INSERT INTO meditation_sessions (id, user_id, type, duration, notes, created_at)
		VALUES ($1, $2, 'travel_plan', 0, $3, NOW())
	`, response.ID, req.UserID, fmt.Sprintf("Destination: %s, Budget: %.2f, Travelers: %d", req.Destination, req.Budget, req.Travelers))
	if err != nil {
		return nil, fmt.Errorf("failed to save travel plan: %w", err)
	}

	return response, nil
}

// MoodEntryRequest 情绪记录请求
type MoodEntryRequest struct {
	UserID      string `json:"user_id"`
	Mood        string `json:"mood"`
	Energy      int    `json:"energy"`
	Stress      int    `json:"stress"`
	Notes       string `json:"notes"`
	Activities  []string `json:"activities"`
	Weather     string `json:"weather"`
}

// MoodEntryResponse 情绪记录响应
type MoodEntryResponse struct {
	ID        string    `json:"id"`
	UserID    string    `json:"user_id"`
	Mood      string    `json:"mood"`
	Energy    int       `json:"energy"`
	Stress    int       `json:"stress"`
	Notes     string    `json:"notes"`
	CreatedAt time.Time `json:"created_at"`
}

// CreateMoodEntry 创建情绪记录
func (s *LifeModeService) CreateMoodEntry(req *MoodEntryRequest) (*MoodEntryResponse, error) {
	response := &MoodEntryResponse{
		ID:        generateUUID(),
		UserID:    req.UserID,
		Mood:      req.Mood,
		Energy:    req.Energy,
		Stress:    req.Stress,
		Notes:     req.Notes,
		CreatedAt: time.Now(),
	}

	// 保存情绪记录
	_, err := s.db.Exec(`
		INSERT INTO mood_entries (id, user_id, mood_type, intensity, notes, created_at)
		VALUES ($1, $2, $3, $4, $5, NOW())
	`, response.ID, req.UserID, req.Mood, req.Energy, req.Notes)
	if err != nil {
		return nil, fmt.Errorf("failed to save mood entry: %w", err)
	}

	return response, nil
}

// GetMoodHistory 获取情绪历史
func (s *LifeModeService) GetMoodHistory(userID string, page, perPage int) ([]MoodEntryResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM mood_entries WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count mood entries: %w", err)
	}

	// 查询情绪记录
	query := `
		SELECT id, user_id, mood_type, intensity, notes, created_at
		FROM mood_entries 
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query mood entries: %w", err)
	}
	defer rows.Close()

	var entries []MoodEntryResponse
	for rows.Next() {
		var entry MoodEntryResponse
		var moodType string
		var intensity int
		err := rows.Scan(
			&entry.ID, &entry.UserID, &moodType, &intensity, &entry.Notes, &entry.CreatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan mood entry: %w", err)
		}
		entry.Mood = moodType
		entry.Energy = intensity
		entry.Stress = 5 // 默认值
		entries = append(entries, entry)
	}

	return entries, total, nil
}

// MeditationSessionRequest 冥想会话请求
type MeditationSessionRequest struct {
	UserID      string `json:"user_id"`
	Duration    int    `json:"duration"`
	Type        string `json:"type"`
	Background  string `json:"background"`
	Mood        string `json:"mood"`
}

// MeditationSessionResponse 冥想会话响应
type MeditationSessionResponse struct {
	ID          string    `json:"id"`
	UserID      string    `json:"user_id"`
	Duration    int       `json:"duration"`
	Type        string    `json:"type"`
	Background  string    `json:"background"`
	Mood        string    `json:"mood"`
	StartedAt   time.Time `json:"started_at"`
	CompletedAt *time.Time `json:"completed_at,omitempty"`
}

// StartMeditationSession 开始冥想会话
func (s *LifeModeService) StartMeditationSession(req *MeditationSessionRequest) (*MeditationSessionResponse, error) {
	response := &MeditationSessionResponse{
		ID:         generateUUID(),
		UserID:     req.UserID,
		Duration:   req.Duration,
		Type:       req.Type,
		Background: req.Background,
		Mood:       req.Mood,
		StartedAt:  time.Now(),
	}

	// 保存冥想会话
	_, err := s.db.Exec(`
		INSERT INTO meditation_sessions (id, user_id, type, duration, notes, created_at)
		VALUES ($1, $2, $3, $4, $5, NOW())
	`, response.ID, req.UserID, req.Type, req.Duration, fmt.Sprintf("Background: %s, Mood: %s", req.Background, req.Mood))
	if err != nil {
		return nil, fmt.Errorf("failed to save meditation session: %w", err)
	}

	return response, nil
}

// GetMeditationHistory 获取冥想历史
func (s *LifeModeService) GetMeditationHistory(userID string, page, perPage int) ([]MeditationSessionResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM meditation_sessions WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count meditation sessions: %w", err)
	}

	// 查询冥想会话
	query := `
		SELECT id, user_id, type, duration, notes, created_at
		FROM meditation_sessions 
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query meditation sessions: %w", err)
	}
	defer rows.Close()

	var sessions []MeditationSessionResponse
	for rows.Next() {
		var session MeditationSessionResponse
		var notes string

		err := rows.Scan(
			&session.ID, &session.UserID, &session.Type, &session.Duration, &notes, &session.StartedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan meditation session: %w", err)
		}

		session.Background = "default"
		session.Mood = "calm"
		session.CompletedAt = &session.StartedAt

		sessions = append(sessions, session)
	}

	return sessions, total, nil
}