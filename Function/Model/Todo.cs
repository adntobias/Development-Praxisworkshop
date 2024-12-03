

using Azure;

namespace Project;

public class Todo : ITableEntity
{
  [JsonProperty(PropertyName = "Id")]
  public string Id { get; set; } = Guid.NewGuid().ToString("n");

  [JsonProperty(PropertyName = "CreatedTime")]
  public DateTime CreatedTime { get; set; } = DateTime.UtcNow;

  [JsonProperty(PropertyName = "TaskDescription")]
  public string TaskDescription { get; set; }

  [JsonProperty(PropertyName = "IsCompleted")]
  public bool IsCompleted { get; set; }
  public string PartitionKey { get; set; }
  public string RowKey { get; set; }
  public DateTimeOffset? Timestamp { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
  public ETag ETag { get; set; }

  public Todo()
  {
    this.PartitionKey = "TODO";
    this.RowKey = new Random().Next(0, 9999999) + ":" + new Random().Next(0, 9999999); ;
    this.ETag = Azure.ETag.All;
    this.Timestamp = DateTimeOffset.UtcNow;
  }

  public Todo(string _rowKey, string _partititonKey)
  {
    this.PartitionKey = _partititonKey ?? "TODO";
    this.RowKey = _rowKey ?? new Random().Next(0, 9999999) + ":" + new Random().Next(0, 9999999); ;
    this.ETag = Azure.ETag.All;
    this.Timestamp = DateTimeOffset.UtcNow;
  }
}