// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Sleep_report_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSleepReportCollection on Isar {
  IsarCollection<SleepReport> get sleepReports => this.collection();
}

const SleepReportSchema = CollectionSchema(
  name: r'SleepReport',
  id: -602473489360408529,
  properties: {
    r'awakeSleepMinutes': PropertySchema(
      id: 0,
      name: r'awakeSleepMinutes',
      type: IsarType.long,
    ),
    r'comment': PropertySchema(
      id: 1,
      name: r'comment',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'deepSleepMinutes': PropertySchema(
      id: 3,
      name: r'deepSleepMinutes',
      type: IsarType.long,
    ),
    r'durationInMinutes': PropertySchema(
      id: 4,
      name: r'durationInMinutes',
      type: IsarType.long,
    ),
    r'formattedAwakeSleep': PropertySchema(
      id: 5,
      name: r'formattedAwakeSleep',
      type: IsarType.string,
    ),
    r'formattedDeepSleep': PropertySchema(
      id: 6,
      name: r'formattedDeepSleep',
      type: IsarType.string,
    ),
    r'formattedLightSleep': PropertySchema(
      id: 7,
      name: r'formattedLightSleep',
      type: IsarType.string,
    ),
    r'formattedRemSleep': PropertySchema(
      id: 8,
      name: r'formattedRemSleep',
      type: IsarType.string,
    ),
    r'formattedTotal': PropertySchema(
      id: 9,
      name: r'formattedTotal',
      type: IsarType.string,
    ),
    r'isSent': PropertySchema(
      id: 10,
      name: r'isSent',
      type: IsarType.bool,
    ),
    r'lightSleepMinutes': PropertySchema(
      id: 11,
      name: r'lightSleepMinutes',
      type: IsarType.long,
    ),
    r'moodIndex': PropertySchema(
      id: 12,
      name: r'moodIndex',
      type: IsarType.long,
    ),
    r'percentAwake': PropertySchema(
      id: 13,
      name: r'percentAwake',
      type: IsarType.double,
    ),
    r'percentDeep': PropertySchema(
      id: 14,
      name: r'percentDeep',
      type: IsarType.double,
    ),
    r'percentLight': PropertySchema(
      id: 15,
      name: r'percentLight',
      type: IsarType.double,
    ),
    r'percentRem': PropertySchema(
      id: 16,
      name: r'percentRem',
      type: IsarType.double,
    ),
    r'remSleepMinutes': PropertySchema(
      id: 17,
      name: r'remSleepMinutes',
      type: IsarType.long,
    ),
    r'sleepRating': PropertySchema(
      id: 18,
      name: r'sleepRating',
      type: IsarType.long,
    ),
    r'sleepScore': PropertySchema(
      id: 19,
      name: r'sleepScore',
      type: IsarType.double,
    )
  },
  estimateSize: _sleepReportEstimateSize,
  serialize: _sleepReportSerialize,
  deserialize: _sleepReportDeserialize,
  deserializeProp: _sleepReportDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isSent': IndexSchema(
      id: 1331618202571566622,
      name: r'isSent',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isSent',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _sleepReportGetId,
  getLinks: _sleepReportGetLinks,
  attach: _sleepReportAttach,
  version: '3.1.0+1',
);

int _sleepReportEstimateSize(
  SleepReport object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.comment;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.formattedAwakeSleep.length * 3;
  bytesCount += 3 + object.formattedDeepSleep.length * 3;
  bytesCount += 3 + object.formattedLightSleep.length * 3;
  bytesCount += 3 + object.formattedRemSleep.length * 3;
  bytesCount += 3 + object.formattedTotal.length * 3;
  return bytesCount;
}

void _sleepReportSerialize(
  SleepReport object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.awakeSleepMinutes);
  writer.writeString(offsets[1], object.comment);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeLong(offsets[3], object.deepSleepMinutes);
  writer.writeLong(offsets[4], object.durationInMinutes);
  writer.writeString(offsets[5], object.formattedAwakeSleep);
  writer.writeString(offsets[6], object.formattedDeepSleep);
  writer.writeString(offsets[7], object.formattedLightSleep);
  writer.writeString(offsets[8], object.formattedRemSleep);
  writer.writeString(offsets[9], object.formattedTotal);
  writer.writeBool(offsets[10], object.isSent);
  writer.writeLong(offsets[11], object.lightSleepMinutes);
  writer.writeLong(offsets[12], object.moodIndex);
  writer.writeDouble(offsets[13], object.percentAwake);
  writer.writeDouble(offsets[14], object.percentDeep);
  writer.writeDouble(offsets[15], object.percentLight);
  writer.writeDouble(offsets[16], object.percentRem);
  writer.writeLong(offsets[17], object.remSleepMinutes);
  writer.writeLong(offsets[18], object.sleepRating);
  writer.writeDouble(offsets[19], object.sleepScore);
}

SleepReport _sleepReportDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SleepReport(
    awakeSleepMinutes: reader.readLong(offsets[0]),
    comment: reader.readStringOrNull(offsets[1]),
    date: reader.readDateTime(offsets[2]),
    deepSleepMinutes: reader.readLong(offsets[3]),
    durationInMinutes: reader.readLong(offsets[4]),
    isSent: reader.readBoolOrNull(offsets[10]) ?? false,
    lightSleepMinutes: reader.readLong(offsets[11]),
    moodIndex: reader.readLongOrNull(offsets[12]),
    remSleepMinutes: reader.readLong(offsets[17]),
    sleepRating: reader.readLongOrNull(offsets[18]),
    sleepScore: reader.readDouble(offsets[19]),
  );
  object.id = id;
  return object;
}

P _sleepReportDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readDouble(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readLongOrNull(offset)) as P;
    case 19:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sleepReportGetId(SleepReport object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sleepReportGetLinks(SleepReport object) {
  return [];
}

void _sleepReportAttach(
    IsarCollection<dynamic> col, Id id, SleepReport object) {
  object.id = id;
}

extension SleepReportQueryWhereSort
    on QueryBuilder<SleepReport, SleepReport, QWhere> {
  QueryBuilder<SleepReport, SleepReport, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhere> anyIsSent() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isSent'),
      );
    });
  }
}

extension SleepReportQueryWhere
    on QueryBuilder<SleepReport, SleepReport, QWhereClause> {
  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateNotEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> isSentEqualTo(
      bool isSent) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isSent',
        value: [isSent],
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterWhereClause> isSentNotEqualTo(
      bool isSent) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSent',
              lower: [],
              upper: [isSent],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSent',
              lower: [isSent],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSent',
              lower: [isSent],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSent',
              lower: [],
              upper: [isSent],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SleepReportQueryFilter
    on QueryBuilder<SleepReport, SleepReport, QFilterCondition> {
  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      awakeSleepMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'awakeSleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      awakeSleepMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'awakeSleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      awakeSleepMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'awakeSleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      awakeSleepMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'awakeSleepMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      commentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'comment',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      commentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'comment',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> commentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      commentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> commentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> commentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'comment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      commentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> commentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> commentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> commentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'comment',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      commentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comment',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      commentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'comment',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      deepSleepMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deepSleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      deepSleepMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deepSleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      deepSleepMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deepSleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      deepSleepMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deepSleepMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      durationInMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationInMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      durationInMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationInMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      durationInMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationInMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      durationInMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationInMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedAwakeSleepEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formattedAwakeSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedAwakeSleepGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'formattedAwakeSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedAwakeSleepLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'formattedAwakeSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedAwakeSleepBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'formattedAwakeSleep',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedAwakeSleepStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'formattedAwakeSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedAwakeSleepEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'formattedAwakeSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedAwakeSleepContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'formattedAwakeSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedAwakeSleepMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'formattedAwakeSleep',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedAwakeSleepIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formattedAwakeSleep',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedAwakeSleepIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'formattedAwakeSleep',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedDeepSleepEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formattedDeepSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedDeepSleepGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'formattedDeepSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedDeepSleepLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'formattedDeepSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedDeepSleepBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'formattedDeepSleep',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedDeepSleepStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'formattedDeepSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedDeepSleepEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'formattedDeepSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedDeepSleepContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'formattedDeepSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedDeepSleepMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'formattedDeepSleep',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedDeepSleepIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formattedDeepSleep',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedDeepSleepIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'formattedDeepSleep',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedLightSleepEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formattedLightSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedLightSleepGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'formattedLightSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedLightSleepLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'formattedLightSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedLightSleepBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'formattedLightSleep',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedLightSleepStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'formattedLightSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedLightSleepEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'formattedLightSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedLightSleepContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'formattedLightSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedLightSleepMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'formattedLightSleep',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedLightSleepIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formattedLightSleep',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedLightSleepIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'formattedLightSleep',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedRemSleepEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formattedRemSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedRemSleepGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'formattedRemSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedRemSleepLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'formattedRemSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedRemSleepBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'formattedRemSleep',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedRemSleepStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'formattedRemSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedRemSleepEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'formattedRemSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedRemSleepContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'formattedRemSleep',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedRemSleepMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'formattedRemSleep',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedRemSleepIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formattedRemSleep',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedRemSleepIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'formattedRemSleep',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedTotalEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formattedTotal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedTotalGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'formattedTotal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedTotalLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'formattedTotal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedTotalBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'formattedTotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedTotalStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'formattedTotal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedTotalEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'formattedTotal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedTotalContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'formattedTotal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedTotalMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'formattedTotal',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedTotalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formattedTotal',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      formattedTotalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'formattedTotal',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition> isSentEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSent',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      lightSleepMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lightSleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      lightSleepMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lightSleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      lightSleepMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lightSleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      lightSleepMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lightSleepMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      moodIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'moodIndex',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      moodIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'moodIndex',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      moodIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      moodIndexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moodIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      moodIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moodIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      moodIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moodIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentAwakeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'percentAwake',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentAwakeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'percentAwake',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentAwakeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'percentAwake',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentAwakeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'percentAwake',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentDeepEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'percentDeep',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentDeepGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'percentDeep',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentDeepLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'percentDeep',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentDeepBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'percentDeep',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentLightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'percentLight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentLightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'percentLight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentLightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'percentLight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentLightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'percentLight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentRemEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'percentRem',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentRemGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'percentRem',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentRemLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'percentRem',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      percentRemBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'percentRem',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      remSleepMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remSleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      remSleepMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remSleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      remSleepMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remSleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      remSleepMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remSleepMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepRatingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sleepRating',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepRatingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sleepRating',
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepRatingEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sleepRating',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepRatingGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sleepRating',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepRatingLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sleepRating',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepRatingBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sleepRating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sleepScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sleepScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sleepScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterFilterCondition>
      sleepScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sleepScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension SleepReportQueryObject
    on QueryBuilder<SleepReport, SleepReport, QFilterCondition> {}

extension SleepReportQueryLinks
    on QueryBuilder<SleepReport, SleepReport, QFilterCondition> {}

extension SleepReportQuerySortBy
    on QueryBuilder<SleepReport, SleepReport, QSortBy> {
  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByAwakeSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awakeSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByAwakeSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awakeSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByComment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByCommentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByDeepSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByDeepSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByDurationInMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByDurationInMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByFormattedAwakeSleep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedAwakeSleep', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByFormattedAwakeSleepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedAwakeSleep', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByFormattedDeepSleep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedDeepSleep', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByFormattedDeepSleepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedDeepSleep', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByFormattedLightSleep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedLightSleep', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByFormattedLightSleepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedLightSleep', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByFormattedRemSleep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedRemSleep', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByFormattedRemSleepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedRemSleep', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByFormattedTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedTotal', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByFormattedTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedTotal', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByIsSent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSent', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByIsSentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSent', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByLightSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lightSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByLightSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lightSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByMoodIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodIndex', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByMoodIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodIndex', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByPercentAwake() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentAwake', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByPercentAwakeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentAwake', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByPercentDeep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentDeep', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByPercentDeepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentDeep', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByPercentLight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentLight', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByPercentLightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentLight', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByPercentRem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentRem', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByPercentRemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentRem', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortByRemSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      sortByRemSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortBySleepRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepRating', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortBySleepRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepRating', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortBySleepScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> sortBySleepScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.desc);
    });
  }
}

extension SleepReportQuerySortThenBy
    on QueryBuilder<SleepReport, SleepReport, QSortThenBy> {
  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByAwakeSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awakeSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByAwakeSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awakeSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByComment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByCommentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByDeepSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByDeepSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByDurationInMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByDurationInMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByFormattedAwakeSleep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedAwakeSleep', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByFormattedAwakeSleepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedAwakeSleep', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByFormattedDeepSleep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedDeepSleep', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByFormattedDeepSleepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedDeepSleep', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByFormattedLightSleep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedLightSleep', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByFormattedLightSleepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedLightSleep', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByFormattedRemSleep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedRemSleep', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByFormattedRemSleepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedRemSleep', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByFormattedTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedTotal', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByFormattedTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedTotal', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByIsSent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSent', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByIsSentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSent', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByLightSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lightSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByLightSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lightSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByMoodIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodIndex', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByMoodIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodIndex', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByPercentAwake() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentAwake', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByPercentAwakeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentAwake', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByPercentDeep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentDeep', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByPercentDeepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentDeep', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByPercentLight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentLight', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByPercentLightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentLight', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByPercentRem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentRem', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByPercentRemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentRem', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenByRemSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remSleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy>
      thenByRemSleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remSleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenBySleepRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepRating', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenBySleepRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepRating', Sort.desc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenBySleepScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.asc);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QAfterSortBy> thenBySleepScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepScore', Sort.desc);
    });
  }
}

extension SleepReportQueryWhereDistinct
    on QueryBuilder<SleepReport, SleepReport, QDistinct> {
  QueryBuilder<SleepReport, SleepReport, QDistinct>
      distinctByAwakeSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'awakeSleepMinutes');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByComment(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'comment', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct>
      distinctByDeepSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deepSleepMinutes');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct>
      distinctByDurationInMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInMinutes');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct>
      distinctByFormattedAwakeSleep({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'formattedAwakeSleep',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct>
      distinctByFormattedDeepSleep({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'formattedDeepSleep',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct>
      distinctByFormattedLightSleep({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'formattedLightSleep',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByFormattedRemSleep(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'formattedRemSleep',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByFormattedTotal(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'formattedTotal',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByIsSent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSent');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct>
      distinctByLightSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lightSleepMinutes');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByMoodIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moodIndex');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByPercentAwake() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'percentAwake');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByPercentDeep() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'percentDeep');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByPercentLight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'percentLight');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctByPercentRem() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'percentRem');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct>
      distinctByRemSleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remSleepMinutes');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctBySleepRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepRating');
    });
  }

  QueryBuilder<SleepReport, SleepReport, QDistinct> distinctBySleepScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepScore');
    });
  }
}

extension SleepReportQueryProperty
    on QueryBuilder<SleepReport, SleepReport, QQueryProperty> {
  QueryBuilder<SleepReport, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> awakeSleepMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'awakeSleepMinutes');
    });
  }

  QueryBuilder<SleepReport, String?, QQueryOperations> commentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'comment');
    });
  }

  QueryBuilder<SleepReport, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> deepSleepMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deepSleepMinutes');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> durationInMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInMinutes');
    });
  }

  QueryBuilder<SleepReport, String, QQueryOperations>
      formattedAwakeSleepProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'formattedAwakeSleep');
    });
  }

  QueryBuilder<SleepReport, String, QQueryOperations>
      formattedDeepSleepProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'formattedDeepSleep');
    });
  }

  QueryBuilder<SleepReport, String, QQueryOperations>
      formattedLightSleepProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'formattedLightSleep');
    });
  }

  QueryBuilder<SleepReport, String, QQueryOperations>
      formattedRemSleepProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'formattedRemSleep');
    });
  }

  QueryBuilder<SleepReport, String, QQueryOperations> formattedTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'formattedTotal');
    });
  }

  QueryBuilder<SleepReport, bool, QQueryOperations> isSentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSent');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> lightSleepMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lightSleepMinutes');
    });
  }

  QueryBuilder<SleepReport, int?, QQueryOperations> moodIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moodIndex');
    });
  }

  QueryBuilder<SleepReport, double, QQueryOperations> percentAwakeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'percentAwake');
    });
  }

  QueryBuilder<SleepReport, double, QQueryOperations> percentDeepProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'percentDeep');
    });
  }

  QueryBuilder<SleepReport, double, QQueryOperations> percentLightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'percentLight');
    });
  }

  QueryBuilder<SleepReport, double, QQueryOperations> percentRemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'percentRem');
    });
  }

  QueryBuilder<SleepReport, int, QQueryOperations> remSleepMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remSleepMinutes');
    });
  }

  QueryBuilder<SleepReport, int?, QQueryOperations> sleepRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepRating');
    });
  }

  QueryBuilder<SleepReport, double, QQueryOperations> sleepScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepScore');
    });
  }
}
