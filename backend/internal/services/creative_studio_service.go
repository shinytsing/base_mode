package services

import (
	"fmt"
	"time"

	"qa-toolbox-backend/internal/database"
)

type CreativeStudioService struct {
	db *database.DB
}

func NewCreativeStudioService(db *database.DB) *CreativeStudioService {
	return &CreativeStudioService{
		db: db,
	}
}

// WritingRequest 写作请求
type WritingRequest struct {
	UserID      string `json:"user_id"`
	Title       string `json:"title"`
	Type        string `json:"type"`
	Topic       string `json:"topic"`
	Requirements string `json:"requirements"`
	Style       string `json:"style"`
	Length      int    `json:"length"`
}

// WritingResponse 写作响应
type WritingResponse struct {
	ID          string    `json:"id"`
	UserID      string    `json:"user_id"`
	Title       string    `json:"title"`
	Type        string    `json:"type"`
	Topic       string    `json:"topic"`
	Content     string    `json:"content"`
	WordCount   int       `json:"word_count"`
	CreatedAt   time.Time `json:"created_at"`
}

// GenerateContent 生成内容
func (s *CreativeStudioService) GenerateContent(req *WritingRequest) (*WritingResponse, error) {
	// 这里应该调用AI服务生成内容
	content := fmt.Sprintf(`
关于"%s"的%s：

%s

这是一个关于%s的%s作品。根据您的要求，我为您创作了以下内容：

%s

希望这个作品能够满足您的需求。如果您需要修改或调整，请随时告诉我。
`, req.Topic, req.Type, req.Requirements, req.Topic, req.Type, req.Requirements)

	response := &WritingResponse{
		ID:        generateUUID(),
		UserID:    req.UserID,
		Title:     req.Title,
		Type:      req.Type,
		Topic:     req.Topic,
		Content:   content,
		WordCount: len(content),
		CreatedAt: time.Now(),
	}

	// 保存写作内容
	_, err := s.db.Exec(`
		INSERT INTO writings (id, user_id, title, type, topic, content, word_count, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
	`, response.ID, req.UserID, req.Title, req.Type, req.Topic, response.Content, req.Length)
	if err != nil {
		return nil, fmt.Errorf("failed to save writing: %w", err)
	}

	return response, nil
}

// GetWritingHistory 获取写作历史
func (s *CreativeStudioService) GetWritingHistory(userID string, page, perPage int) ([]WritingResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM writings WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count writings: %w", err)
	}

	// 查询写作记录
	query := `
		SELECT id, user_id, title, type, topic, content, word_count, created_at
		FROM writings 
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query writings: %w", err)
	}
	defer rows.Close()

	var writings []WritingResponse
	for rows.Next() {
		var writing WritingResponse
		err := rows.Scan(
			&writing.ID, &writing.UserID, &writing.Title, &writing.Type,
			&writing.Topic, &writing.Content, &writing.WordCount, &writing.CreatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan writing: %w", err)
		}
		writings = append(writings, writing)
	}

	return writings, total, nil
}

// AvatarRequest 头像生成请求
type AvatarRequest struct {
	UserID      string `json:"user_id"`
	Style       string `json:"style"`
	Gender      string `json:"gender"`
	Age         string `json:"age"`
	Description string `json:"description"`
}

// AvatarResponse 头像生成响应
type AvatarResponse struct {
	ID          string    `json:"id"`
	UserID      string    `json:"user_id"`
	Style       string    `json:"style"`
	Gender      string    `json:"gender"`
	Age         string    `json:"age"`
	ImageURL    string    `json:"image_url"`
	Prompt      string    `json:"prompt"`
	CreatedAt   time.Time `json:"created_at"`
}

// GenerateAvatar 生成头像
func (s *CreativeStudioService) GenerateAvatar(req *AvatarRequest) (*AvatarResponse, error) {
	// 这里应该调用AI图像生成服务
	prompt := fmt.Sprintf("A %s %s %s avatar, %s", req.Age, req.Gender, req.Style, req.Description)
	imageURL := "https://example.com/generated-avatar.jpg"

	response := &AvatarResponse{
		ID:        generateUUID(),
		UserID:    req.UserID,
		Style:     req.Style,
		Gender:    req.Gender,
		Age:       req.Age,
		ImageURL:  imageURL,
		Prompt:    prompt,
		CreatedAt: time.Now(),
	}

	// 保存头像记录
	_, err := s.db.Exec(`
		INSERT INTO avatars (id, user_id, style, gender, age, image_url, prompt, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
	`, response.ID, req.UserID, req.Style, req.Gender, req.Age, imageURL, prompt)
	if err != nil {
		return nil, fmt.Errorf("failed to save avatar: %w", err)
	}

	return response, nil
}

// GetAvatars 获取头像列表
func (s *CreativeStudioService) GetAvatars(userID string, page, perPage int) ([]AvatarResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM avatars WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count avatars: %w", err)
	}

	// 查询头像记录
	query := `
		SELECT id, user_id, style, gender, age, image_url, prompt, created_at
		FROM avatars 
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query avatars: %w", err)
	}
	defer rows.Close()

	var avatars []AvatarResponse
	for rows.Next() {
		var avatar AvatarResponse
		err := rows.Scan(
			&avatar.ID, &avatar.UserID, &avatar.Style, &avatar.Gender,
			&avatar.Age, &avatar.ImageURL, &avatar.Prompt, &avatar.CreatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan avatar: %w", err)
		}
		avatars = append(avatars, avatar)
	}

	return avatars, total, nil
}

// MusicCompositionRequest 音乐创作请求
type MusicCompositionRequest struct {
	UserID      string `json:"user_id"`
	Title       string `json:"title"`
	Genre       string `json:"genre"`
	Mood        string `json:"mood"`
	Duration    int    `json:"duration"`
	Instruments []string `json:"instruments"`
	Description string `json:"description"`
}

// MusicCompositionResponse 音乐创作响应
type MusicCompositionResponse struct {
	ID          string    `json:"id"`
	UserID      string    `json:"user_id"`
	Title       string    `json:"title"`
	Genre       string    `json:"genre"`
	Mood        string    `json:"mood"`
	Duration    int       `json:"duration"`
	AudioURL    string    `json:"audio_url"`
	ScoreURL    string    `json:"score_url"`
	CreatedAt   time.Time `json:"created_at"`
}

// ComposeMusic 创作音乐
func (s *CreativeStudioService) ComposeMusic(req *MusicCompositionRequest) (*MusicCompositionResponse, error) {
	// 这里应该调用AI音乐生成服务
	audioURL := "https://example.com/generated-music.mp3"
	scoreURL := "https://example.com/music-score.pdf"

	response := &MusicCompositionResponse{
		ID:        generateUUID(),
		UserID:    req.UserID,
		Title:     req.Title,
		Genre:     req.Genre,
		Mood:      req.Mood,
		Duration:  req.Duration,
		AudioURL:  audioURL,
		ScoreURL:  scoreURL,
		CreatedAt: time.Now(),
	}

	// 保存音乐创作记录
	_, err := s.db.Exec(`
		INSERT INTO music_compositions (id, user_id, title, genre, mood, duration, audio_url, score_url, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW())
	`, response.ID, req.UserID, req.Title, req.Genre, req.Mood, req.Duration, audioURL, scoreURL)
	if err != nil {
		return nil, fmt.Errorf("failed to save music composition: %w", err)
	}

	return response, nil
}

// GetMusicCompositions 获取音乐创作列表
func (s *CreativeStudioService) GetMusicCompositions(userID string, page, perPage int) ([]MusicCompositionResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM music_compositions WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count music compositions: %w", err)
	}

	// 查询音乐创作记录
	query := `
		SELECT id, user_id, title, genre, mood, duration, audio_url, score_url, created_at
		FROM music_compositions 
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query music compositions: %w", err)
	}
	defer rows.Close()

	var compositions []MusicCompositionResponse
	for rows.Next() {
		var composition MusicCompositionResponse
		err := rows.Scan(
			&composition.ID, &composition.UserID, &composition.Title, &composition.Genre,
			&composition.Mood, &composition.Duration, &composition.AudioURL, &composition.ScoreURL, &composition.CreatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan music composition: %w", err)
		}
		compositions = append(compositions, composition)
	}

	return compositions, total, nil
}

// DesignRequest 设计请求
type DesignRequest struct {
	UserID      string `json:"user_id"`
	Title       string `json:"title"`
	Type        string `json:"type"`
	Style       string `json:"style"`
	Description string `json:"description"`
	Dimensions  string `json:"dimensions"`
	Colors      []string `json:"colors"`
}

// DesignResponse 设计响应
type DesignResponse struct {
	ID          string    `json:"id"`
	UserID      string    `json:"user_id"`
	Title       string    `json:"title"`
	Type        string    `json:"type"`
	Style       string    `json:"style"`
	ImageURL    string    `json:"image_url"`
	SourceURL   string    `json:"source_url"`
	CreatedAt   time.Time `json:"created_at"`
}

// CreateDesign 创建设计
func (s *CreativeStudioService) CreateDesign(req *DesignRequest) (*DesignResponse, error) {
	// 这里应该调用AI设计生成服务
	imageURL := "https://example.com/generated-design.png"
	sourceURL := "https://example.com/design-source.ai"

	response := &DesignResponse{
		ID:        generateUUID(),
		UserID:    req.UserID,
		Title:     req.Title,
		Type:      req.Type,
		Style:     req.Style,
		ImageURL:  imageURL,
		SourceURL: sourceURL,
		CreatedAt: time.Now(),
	}

	// 保存设计记录
	_, err := s.db.Exec(`
		INSERT INTO designs (id, user_id, title, type, style, image_url, source_url, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
	`, response.ID, req.UserID, req.Title, req.Type, req.Style, imageURL, sourceURL)
	if err != nil {
		return nil, fmt.Errorf("failed to save design: %w", err)
	}

	return response, nil
}

// GetDesigns 获取设计列表
func (s *CreativeStudioService) GetDesigns(userID string, page, perPage int) ([]DesignResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM designs WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count designs: %w", err)
	}

	// 查询设计记录
	query := `
		SELECT id, user_id, title, type, style, image_url, source_url, created_at
		FROM designs 
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query designs: %w", err)
	}
	defer rows.Close()

	var designs []DesignResponse
	for rows.Next() {
		var design DesignResponse
		err := rows.Scan(
			&design.ID, &design.UserID, &design.Title, &design.Type,
			&design.Style, &design.ImageURL, &design.SourceURL, &design.CreatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan design: %w", err)
		}
		designs = append(designs, design)
	}

	return designs, total, nil
}