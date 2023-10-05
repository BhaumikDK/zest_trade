// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TradeModel _$TradeModelFromJson(Map<String, dynamic> json) => TradeModel(
      id: json['id'] as int?,
      mentorId: json['mentor_id'] as int?,
      type: json['type'] as String?,
      entryPrice: json['entry_price'] as int?,
      name: json['name'] as String?,
      stock: json['stock'] as String?,
      exitPrice: json['exit_price'] as int?,
      exitHigh: json['exit_high'] as int?,
      stopLossPrice: json['stop_loss_price'] as int?,
      action: json['action'] as String?,
      result: json['result'] as String?,
      status: json['status'] as String?,
      providedDate: json['posted_date'] as String?,
      fee: json['fee'] as String?,
      isSubscribe: json['is_subscribe'] as int?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TradeModelToJson(TradeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mentor_id': instance.mentorId,
      'type': instance.type,
      'entry_price': instance.entryPrice,
      'name': instance.name,
      'stock': instance.stock,
      'exit_price': instance.exitPrice,
      'exit_high': instance.exitHigh,
      'stop_loss_price': instance.stopLossPrice,
      'action': instance.action,
      'result': instance.result,
      'status': instance.status,
      'posted_date': instance.providedDate,
      'fee': instance.fee,
      'is_subscribe': instance.isSubscribe,
      'user': instance.user,
    };
