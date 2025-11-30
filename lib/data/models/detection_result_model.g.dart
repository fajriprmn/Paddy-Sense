// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detection_result_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DetectionResultModelAdapter extends TypeAdapter<DetectionResultModel> {
  @override
  final int typeId = 0;

  @override
  DetectionResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DetectionResultModel(
      id: fields[0] as String,
      imagePath: fields[1] as String,
      diseaseName: fields[2] as String,
      diseaseScientific: fields[3] as String,
      diseaseType: fields[4] as String,
      confidence: fields[5] as double,
      detectionTime: fields[6] as DateTime,
      status: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DetectionResultModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.diseaseName)
      ..writeByte(3)
      ..write(obj.diseaseScientific)
      ..writeByte(4)
      ..write(obj.diseaseType)
      ..writeByte(5)
      ..write(obj.confidence)
      ..writeByte(6)
      ..write(obj.detectionTime)
      ..writeByte(7)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetectionResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
