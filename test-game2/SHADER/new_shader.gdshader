shader_type spatial;
render_mode unshaded; // Убираем стандартное освещение для кастомного расчета

// Параметры эффекта
uniform float smoothness : hint_range(0.0, 1.0) = 0.8;
uniform float radius_ratio : hint_range(0.5, 1.0) = 0.9;
uniform vec4 base_color : source_color = vec4(0.3, 0.5, 1.0, 1.0);

// Функция сферизации нормалей
vec3 spherical_normal(vec3 pos, vec3 original_normal) {
    // Вычисляем вектор от центра куба к вершине
    vec3 sphere_dir = normalize(pos);

    // Интерполяция между оригинальной и сферической нормалью
    return mix(original_normal, sphere_dir, smoothness);
}

void vertex() {
    // Сохраняем оригинальные координаты вершины
    vec3 orig_vertex = VERTEX;

    // Сферизация позиции (опционально для геометрии)
    VERTEX = normalize(orig_vertex) * length(orig_vertex) * radius_ratio;

    // Модифицируем нормали
    NORMAL = spherical_normal(orig_vertex, NORMAL);
}

void fragment() {
    // Расчёт освещения по модифицированным нормалям
    vec3 light_dir = normalize(vec3(1.0, 2.0, 1.0));
    float diff = max(dot(NORMAL, light_dir), 0.0);

    // Эффект Френеля для краёв
    float fresnel = pow(1.0 - abs(dot(NORMAL, VIEW)), 2.0);

    // Сборка финального цвета
    ALBEDO = base_color.rgb * (diff * 0.8 + 0.2) + fresnel * 0.3;
    ALPHA = base_color.a;

    // Настройки материала
    METALLIC = 0.2;
    ROUGHNESS = 1.0 - smoothness;
    SPECULAR = 0.5;
}