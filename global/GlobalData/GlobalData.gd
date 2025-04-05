# GlobalData.gd
extends Node

# 数据缓存字典（可存储任意类型数据或节点引用）
var data_cache: Dictionary = {}

# 信号：数据变更时触发（可选）
signal data_updated(key, old_value, new_value)

# 设置数据
func set_data(key: String, value) -> void:
	var old_value = data_cache.get(key)
	data_cache[key] = value
	emit_signal("data_updated", key, old_value, value)

# 获取数据（支持默认值）
func get_data(key: String, default = null):
	return data_cache.get(key, default)

# 删除数据
func remove_data(key: String) -> void:
	if data_cache.has(key):
		data_cache.erase(key)
