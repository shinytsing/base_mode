package services

import (
	"database/sql"
	"fmt"
	"time"

	"qa-toolbox-backend/internal/database"
)

type SocialHubService struct {
	db *database.DB
}

func NewSocialHubService(db *database.DB) *SocialHubService {
	return &SocialHubService{
		db: db,
	}
}

// MatchRequest 匹配请求
type MatchRequest struct {
	UserID      string   `json:"user_id"`
	Interests   []string `json:"interests"`
	AgeRange    string   `json:"age_range"`
	Location    string   `json:"location"`
	Gender      string   `json:"gender"`
	LookingFor  string   `json:"looking_for"`
}

// MatchResponse 匹配响应
type MatchResponse struct {
	ID        string    `json:"id"`
	UserID    string    `json:"user_id"`
	Matches   []Match   `json:"matches"`
	CreatedAt time.Time `json:"created_at"`
}

type Match struct {
	UserID      string   `json:"user_id"`
	Username    string   `json:"username"`
	Avatar      string   `json:"avatar"`
	Age         int      `json:"age"`
	Location    string   `json:"location"`
	Interests   []string `json:"interests"`
	Compatibility float64 `json:"compatibility"`
	Distance    float64  `json:"distance"`
}

// FindMatches 查找匹配
func (s *SocialHubService) FindMatches(req *MatchRequest) (*MatchResponse, error) {
	// 这里应该实现匹配算法
	matches := []Match{
		{
			UserID:        "user123",
			Username:      "小明",
			Avatar:        "https://example.com/avatar1.jpg",
			Age:           25,
			Location:      "北京市",
			Interests:     []string{"音乐", "电影", "旅行"},
			Compatibility: 85.5,
			Distance:      2.3,
		},
		{
			UserID:        "user456",
			Username:      "小红",
			Avatar:        "https://example.com/avatar2.jpg",
			Age:           23,
			Location:      "上海市",
			Interests:     []string{"读书", "摄影", "美食"},
			Compatibility: 78.2,
			Distance:      5.7,
		},
	}

	response := &MatchResponse{
		ID:        generateUUID(),
		UserID:    req.UserID,
		Matches:   matches,
		CreatedAt: time.Now(),
	}

	// 保存匹配结果
	_, err := s.db.Exec(`
		INSERT INTO matches (id, user_id, matched_user_id, match_type, status, created_at)
		VALUES ($1, $2, $2, 'social_match', 'active', NOW())
	`, response.ID, req.UserID)
	if err != nil {
		return nil, fmt.Errorf("failed to save matches: %w", err)
	}

	return response, nil
}

// GetMatches 获取匹配历史
func (s *SocialHubService) GetMatches(userID string, page, perPage int) ([]MatchResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM matches WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count matches: %w", err)
	}

	// 查询匹配记录
	query := `
		SELECT id, user_id, matched_user_id, match_type, status, created_at
		FROM matches 
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query matches: %w", err)
	}
	defer rows.Close()

	var matches []MatchResponse
	for rows.Next() {
		var match MatchResponse
		var matchedUserID, matchType, status string
		err := rows.Scan(&match.ID, &match.UserID, &matchedUserID, &matchType, &status, &match.CreatedAt)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan match: %w", err)
		}
		// 创建模拟匹配数据
		match.Matches = []Match{
			{
				UserID:        matchedUserID,
				Username:      "模拟用户",
				Avatar:        "https://example.com/avatar.jpg",
				Age:           25,
				Location:      "北京市",
				Interests:     []string{"音乐", "电影"},
				Compatibility: 85.5,
				Distance:      2.3,
			},
		}
		matches = append(matches, match)
	}

	return matches, total, nil
}

// ActivityRequest 活动请求
type ActivityRequest struct {
	UserID      string   `json:"user_id"`
	Title       string   `json:"title"`
	Description string   `json:"description"`
	Type        string   `json:"type"`
	Location    string   `json:"location"`
	Date        string   `json:"date"`
	Time        string   `json:"time"`
	MaxParticipants int  `json:"max_participants"`
	Tags        []string `json:"tags"`
}

// ActivityResponse 活动响应
type ActivityResponse struct {
	ID              string    `json:"id"`
	UserID          string    `json:"user_id"`
	Title           string    `json:"title"`
	Description     string    `json:"description"`
	Type            string    `json:"type"`
	Location        string    `json:"location"`
	Date            string    `json:"date"`
	Time            string    `json:"time"`
	MaxParticipants int       `json:"max_participants"`
	CurrentParticipants int   `json:"current_participants"`
	Tags            []string  `json:"tags"`
	Status          string    `json:"status"`
	CreatedAt       time.Time `json:"created_at"`
}

// CreateActivity 创建活动
func (s *SocialHubService) CreateActivity(req *ActivityRequest) (*ActivityResponse, error) {
	response := &ActivityResponse{
		ID:              generateUUID(),
		UserID:          req.UserID,
		Title:           req.Title,
		Description:     req.Description,
		Type:            req.Type,
		Location:        req.Location,
		Date:            req.Date,
		Time:            req.Time,
		MaxParticipants: req.MaxParticipants,
		CurrentParticipants: 1, // 创建者自动参与
		Tags:            req.Tags,
		Status:          "active",
		CreatedAt:       time.Now(),
	}

	// 保存活动
	_, err := s.db.Exec(`
		INSERT INTO activities (id, user_id, title, description, type, location, date, time, max_participants, current_participants, tags, status, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, NOW())
	`, response.ID, req.UserID, req.Title, req.Description, req.Type, req.Location, req.Date, req.Time, req.MaxParticipants, 1, req.Tags, "active")
	if err != nil {
		return nil, fmt.Errorf("failed to save activity: %w", err)
	}

	return response, nil
}

// GetActivities 获取活动列表
func (s *SocialHubService) GetActivities(userID string, page, perPage int) ([]ActivityResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM activities WHERE status = 'active'", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count activities: %w", err)
	}

	// 查询活动
	query := `
		SELECT id, user_id, title, description, type, location, date, time, max_participants, current_participants, tags, status, created_at
		FROM activities 
		WHERE status = 'active'
		ORDER BY created_at DESC
		LIMIT $1 OFFSET $2
	`

	rows, err := s.db.Query(query, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query activities: %w", err)
	}
	defer rows.Close()

	var activities []ActivityResponse
	for rows.Next() {
		var activity ActivityResponse
		err := rows.Scan(
			&activity.ID, &activity.UserID, &activity.Title, &activity.Description,
			&activity.Type, &activity.Location, &activity.Date, &activity.Time,
			&activity.MaxParticipants, &activity.CurrentParticipants, &activity.Tags,
			&activity.Status, &activity.CreatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan activity: %w", err)
		}
		activities = append(activities, activity)
	}

	return activities, total, nil
}

// JoinActivity 参与活动
func (s *SocialHubService) JoinActivity(userID, activityID string) error {
	// 检查活动是否存在且未满员
	var maxParticipants, currentParticipants int
	err := s.db.QueryRow(`
		SELECT max_participants, current_participants 
		FROM activities 
		WHERE id = $1 AND status = 'active'
	`, activityID).Scan(&maxParticipants, &currentParticipants)
	if err != nil {
		if err == sql.ErrNoRows {
			return fmt.Errorf("activity not found")
		}
		return fmt.Errorf("failed to query activity: %w", err)
	}

	if currentParticipants >= maxParticipants {
		return fmt.Errorf("activity is full")
	}

	// 检查用户是否已参与
	var exists bool
	err = s.db.QueryRow(`
		SELECT EXISTS(SELECT 1 FROM activity_participants WHERE user_id = $1 AND activity_id = $2)
	`, userID, activityID).Scan(&exists)
	if err != nil {
		return fmt.Errorf("failed to check participation: %w", err)
	}
	if exists {
		return fmt.Errorf("user already joined this activity")
	}

	// 添加参与者
	_, err = s.db.Exec(`
		INSERT INTO activity_participants (user_id, activity_id, joined_at)
		VALUES ($1, $2, NOW())
	`, userID, activityID)
	if err != nil {
		return fmt.Errorf("failed to join activity: %w", err)
	}

	// 更新参与者数量
	_, err = s.db.Exec(`
		UPDATE activities 
		SET current_participants = current_participants + 1
		WHERE id = $1
	`, activityID)
	if err != nil {
		return fmt.Errorf("failed to update participant count: %w", err)
	}

	return nil
}

// MessageRequest 消息请求
type MessageRequest struct {
	UserID    string `json:"user_id"`
	ChatID    string `json:"chat_id"`
	Content   string `json:"content"`
	Type      string `json:"type"`
	ReplyTo   string `json:"reply_to,omitempty"`
}

// MessageResponse 消息响应
type MessageResponse struct {
	ID        string    `json:"id"`
	UserID    string    `json:"user_id"`
	ChatID    string    `json:"chat_id"`
	Content   string    `json:"content"`
	Type      string    `json:"type"`
	ReplyTo   string    `json:"reply_to,omitempty"`
	CreatedAt time.Time `json:"created_at"`
}

// SendMessage 发送消息
func (s *SocialHubService) SendMessage(req *MessageRequest) (*MessageResponse, error) {
	response := &MessageResponse{
		ID:        generateUUID(),
		UserID:    req.UserID,
		ChatID:    req.ChatID,
		Content:   req.Content,
		Type:      req.Type,
		ReplyTo:   req.ReplyTo,
		CreatedAt: time.Now(),
	}

	// 保存消息到chat_messages表
	_, err := s.db.Exec(`
		INSERT INTO chat_messages (id, chat_room_id, user_id, content, message_type, created_at)
		VALUES ($1, $2, $3, $4, $5, NOW())
	`, response.ID, req.ChatID, req.UserID, req.Content, req.Type)
	if err != nil {
		return nil, fmt.Errorf("failed to save message: %w", err)
	}

	return response, nil
}

// GetMessages 获取消息列表
func (s *SocialHubService) GetMessages(chatID string, page, perPage int) ([]MessageResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM chat_messages WHERE chat_room_id = $1", chatID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count messages: %w", err)
	}

	// 查询消息
	query := `
		SELECT id, chat_room_id, user_id, content, message_type, created_at
		FROM chat_messages 
		WHERE chat_room_id = $1
		ORDER BY created_at ASC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, chatID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query messages: %w", err)
	}
	defer rows.Close()

	var messages []MessageResponse
	for rows.Next() {
		var message MessageResponse
		var chatRoomID string

		err := rows.Scan(
			&message.ID, &chatRoomID, &message.UserID, &message.Content,
			&message.Type, &message.CreatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan message: %w", err)
		}

		message.ChatID = chatRoomID
		message.ReplyTo = ""

		messages = append(messages, message)
	}

	return messages, total, nil
}