using System;
using Azure.Messaging.EventHubs;
using Azure.Messaging.EventHubs.Producer;

public class Program
{
    private const string connectionString = "Your Event Hub Namespace Connection String";
    private const string eventHubName = "source-eventhub";

    public static async Task Main()
    {
        await using (var producerClient = new EventHubProducerClient(connectionString, eventHubName))
        {
            using EventDataBatch eventBatch = await producerClient.CreateBatchAsync();

            for (int i = 1; i <= 100; i++)
            {
                eventBatch.TryAdd(new EventData(Encoding.UTF8.GetBytes($"Message {i}")));
            }

            await producerClient.SendAsync(eventBatch);
            Console.WriteLine("Batch of events published.");
        }
    }
}