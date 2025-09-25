package services

import (
	"fmt"
	"time"

	"qa-toolbox-backend/internal/database"
)

type FitTrackerService struct {
	db *database.DB
}

func NewFitTrackerService(db *database.DB) *FitTrackerService {
	return &FitTrackerService{
		db: db,
	}
}

// WorkoutRequest 运动记录请求
type WorkoutRequest struct {
	UserID      string  `json:"user_id"`
	Type        string  `json:"type"`
	Duration    int     `json:"duration"`
	Distance    float64 `json:"distance"`
	Calories    int     `json:"calories"`
	HeartRate   int     `json:"heart_rate"`
	Notes       string  `json:"notes"`
	Date        string  `json:"date"`
}

// WorkoutResponse 运动记录响应
type WorkoutResponse struct {
	ID        string    `json:"id"`
	UserID    string    `json:"user_id"`
	Type      string    `json:"type"`
	Duration  int       `json:"duration"`
	Distance  float64   `json:"distance"`
	Calories  int       `json:"calories"`
	HeartRate int       `json:"heart_rate"`
	Notes     string    `json:"notes"`
	Date      string    `json:"date"`
	CreatedAt time.Time `json:"created_at"`
}

// CreateWorkout 创建运动记录
func (s *FitTrackerService) CreateWorkout(req *WorkoutRequest) (*WorkoutResponse, error) {
	response := &WorkoutResponse{
		ID:        generateUUID(),
		UserID:    req.UserID,
		Type:      req.Type,
		Duration:  req.Duration,
		Distance:  req.Distance,
		Calories:  req.Calories,
		HeartRate: req.HeartRate,
		Notes:     req.Notes,
		Date:      req.Date,
		CreatedAt: time.Now(),
	}

	// 保存运动记录
	_, err := s.db.Exec(`
		INSERT INTO workouts (id, user_id, name, type, duration, calories_burned, notes, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
	`, response.ID, req.UserID, req.Type, req.Type, req.Duration, req.Calories, req.Notes)
	if err != nil {
		return nil, fmt.Errorf("failed to save workout: %w", err)
	}

	return response, nil
}

// GetWorkouts 获取运动记录
func (s *FitTrackerService) GetWorkouts(userID string, page, perPage int) ([]WorkoutResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM workouts WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count workouts: %w", err)
	}

	// 查询运动记录
	query := `
		SELECT id, user_id, type, duration, distance, calories, heart_rate, notes, date, created_at
		FROM workouts 
		WHERE user_id = $1
		ORDER BY date DESC, created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query workouts: %w", err)
	}
	defer rows.Close()

	var workouts []WorkoutResponse
	for rows.Next() {
		var workout WorkoutResponse
		err := rows.Scan(
			&workout.ID, &workout.UserID, &workout.Type, &workout.Duration,
			&workout.Distance, &workout.Calories, &workout.HeartRate,
			&workout.Notes, &workout.Date, &workout.CreatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan workout: %w", err)
		}
		workouts = append(workouts, workout)
	}

	return workouts, total, nil
}

// NutritionLogRequest 营养记录请求
type NutritionLogRequest struct {
	UserID      string  `json:"user_id"`
	Food        string  `json:"food"`
	Amount      float64 `json:"amount"`
	Unit        string  `json:"unit"`
	Calories    int     `json:"calories"`
	Protein     float64 `json:"protein"`
	Carbohydrates float64 `json:"carbohydrates"`
	Fat         float64 `json:"fat"`
	MealType    string  `json:"meal_type"`
	Date        string  `json:"date"`
}

// NutritionLogResponse 营养记录响应
type NutritionLogResponse struct {
	ID              string    `json:"id"`
	UserID          string    `json:"user_id"`
	Food            string    `json:"food"`
	Amount          float64   `json:"amount"`
	Unit            string    `json:"unit"`
	Calories        int       `json:"calories"`
	Protein         float64   `json:"protein"`
	Carbohydrates   float64   `json:"carbohydrates"`
	Fat             float64   `json:"fat"`
	MealType        string    `json:"meal_type"`
	Date            string    `json:"date"`
	CreatedAt       time.Time `json:"created_at"`
}

// LogNutrition 记录营养
func (s *FitTrackerService) LogNutrition(req *NutritionLogRequest) (*NutritionLogResponse, error) {
	response := &NutritionLogResponse{
		ID:              generateUUID(),
		UserID:          req.UserID,
		Food:            req.Food,
		Amount:          req.Amount,
		Unit:            req.Unit,
		Calories:        req.Calories,
		Protein:         req.Protein,
		Carbohydrates:   req.Carbohydrates,
		Fat:             req.Fat,
		MealType:        req.MealType,
		Date:            req.Date,
		CreatedAt:       time.Now(),
	}

	// 保存营养记录
	_, err := s.db.Exec(`
		INSERT INTO nutrition_logs (id, user_id, food, amount, unit, calories, protein, carbohydrates, fat, meal_type, date, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, NOW())
	`, response.ID, req.UserID, req.Food, req.Amount, req.Unit, req.Calories, req.Protein, req.Carbohydrates, req.Fat, req.MealType, req.Date)
	if err != nil {
		return nil, fmt.Errorf("failed to save nutrition log: %w", err)
	}

	return response, nil
}

// GetNutritionHistory 获取营养历史
func (s *FitTrackerService) GetNutritionHistory(userID string, page, perPage int) ([]NutritionLogResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM nutrition_logs WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count nutrition logs: %w", err)
	}

	// 查询营养记录
	query := `
		SELECT id, user_id, food, amount, unit, calories, protein, carbohydrates, fat, meal_type, date, created_at
		FROM nutrition_logs 
		WHERE user_id = $1
		ORDER BY date DESC, created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query nutrition logs: %w", err)
	}
	defer rows.Close()

	var logs []NutritionLogResponse
	for rows.Next() {
		var log NutritionLogResponse
		err := rows.Scan(
			&log.ID, &log.UserID, &log.Food, &log.Amount, &log.Unit,
			&log.Calories, &log.Protein, &log.Carbohydrates, &log.Fat,
			&log.MealType, &log.Date, &log.CreatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan nutrition log: %w", err)
		}
		logs = append(logs, log)
	}

	return logs, total, nil
}

// HealthMetricRequest 健康指标请求
type HealthMetricRequest struct {
	UserID      string  `json:"user_id"`
	Type        string  `json:"type"`
	Value       float64 `json:"value"`
	Unit        string  `json:"unit"`
	Date        string  `json:"date"`
	Notes       string  `json:"notes"`
}

// HealthMetricResponse 健康指标响应
type HealthMetricResponse struct {
	ID        string    `json:"id"`
	UserID    string    `json:"user_id"`
	Type      string    `json:"type"`
	Value     float64   `json:"value"`
	Unit      string    `json:"unit"`
	Date      string    `json:"date"`
	Notes     string    `json:"notes"`
	CreatedAt time.Time `json:"created_at"`
}

// LogHealthMetric 记录健康指标
func (s *FitTrackerService) LogHealthMetric(req *HealthMetricRequest) (*HealthMetricResponse, error) {
	response := &HealthMetricResponse{
		ID:        generateUUID(),
		UserID:    req.UserID,
		Type:      req.Type,
		Value:     req.Value,
		Unit:      req.Unit,
		Date:      req.Date,
		Notes:     req.Notes,
		CreatedAt: time.Now(),
	}

	// 保存健康指标
	_, err := s.db.Exec(`
		INSERT INTO health_metrics (id, user_id, type, value, unit, date, notes, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
	`, response.ID, req.UserID, req.Type, req.Value, req.Unit, req.Date, req.Notes)
	if err != nil {
		return nil, fmt.Errorf("failed to save health metric: %w", err)
	}

	return response, nil
}

// GetHealthMetrics 获取健康指标
func (s *FitTrackerService) GetHealthMetrics(userID string, page, perPage int) ([]HealthMetricResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM health_metrics WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count health metrics: %w", err)
	}

	// 查询健康指标
	query := `
		SELECT id, user_id, type, value, unit, date, notes, created_at
		FROM health_metrics 
		WHERE user_id = $1
		ORDER BY date DESC, created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query health metrics: %w", err)
	}
	defer rows.Close()

	var metrics []HealthMetricResponse
	for rows.Next() {
		var metric HealthMetricResponse
		err := rows.Scan(
			&metric.ID, &metric.UserID, &metric.Type, &metric.Value,
			&metric.Unit, &metric.Date, &metric.Notes, &metric.CreatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan health metric: %w", err)
		}
		metrics = append(metrics, metric)
	}

	return metrics, total, nil
}

// HabitCheckInRequest 习惯打卡请求
type HabitCheckInRequest struct {
	UserID    string `json:"user_id"`
	HabitID   string `json:"habit_id"`
	Date      string `json:"date"`
	Completed bool   `json:"completed"`
	Notes     string `json:"notes"`
}

// HabitCheckInResponse 习惯打卡响应
type HabitCheckInResponse struct {
	ID        string    `json:"id"`
	UserID    string    `json:"user_id"`
	HabitID   string    `json:"habit_id"`
	Date      string    `json:"date"`
	Completed bool      `json:"completed"`
	Notes     string    `json:"notes"`
	CreatedAt time.Time `json:"created_at"`
}

// CheckInHabit 习惯打卡
func (s *FitTrackerService) CheckInHabit(req *HabitCheckInRequest) (*HabitCheckInResponse, error) {
	response := &HabitCheckInResponse{
		ID:        generateUUID(),
		UserID:    req.UserID,
		HabitID:   req.HabitID,
		Date:      req.Date,
		Completed: req.Completed,
		Notes:     req.Notes,
		CreatedAt: time.Now(),
	}

	// 保存习惯打卡
	_, err := s.db.Exec(`
		INSERT INTO habit_checkins (id, user_id, habit_id, date, completed, notes, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, NOW())
	`, response.ID, req.UserID, req.HabitID, req.Date, req.Completed, req.Notes)
	if err != nil {
		return nil, fmt.Errorf("failed to save habit checkin: %w", err)
	}

	return response, nil
}

// GetHabits 获取习惯列表
func (s *FitTrackerService) GetHabits(userID string, page, perPage int) ([]HabitResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM habits WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count habits: %w", err)
	}

	// 查询习惯
	query := `
		SELECT id, user_id, name, description, frequency, target_days, created_at
		FROM habits 
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query habits: %w", err)
	}
	defer rows.Close()

	var habits []HabitResponse
	for rows.Next() {
		var habit HabitResponse
		err := rows.Scan(
			&habit.ID, &habit.UserID, &habit.Name, &habit.Description,
			&habit.Frequency, &habit.TargetDays, &habit.CreatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan habit: %w", err)
		}
		habits = append(habits, habit)
	}

	return habits, total, nil
}

// HabitResponse 习惯响应
type HabitResponse struct {
	ID          string    `json:"id"`
	UserID      string    `json:"user_id"`
	Name        string    `json:"name"`
	Description string    `json:"description"`
	Frequency   string    `json:"frequency"`
	TargetDays  int       `json:"target_days"`
	CreatedAt   time.Time `json:"created_at"`
}