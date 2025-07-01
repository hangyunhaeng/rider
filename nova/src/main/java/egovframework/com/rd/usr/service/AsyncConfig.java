package egovframework.com.rd.usr.service;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

@Configuration
@EnableAsync
public class AsyncConfig {

    // 1. 스레드풀에 corePoolSize 만큼 스레드를 만들어서 비동기 작업 수행
    // 2. 스레드풀의 스레드가 모두 사용중이라면, queueCapacity 만큼 스레드풀의 큐에 작업을 쌓아놓는다.
    // 3. 만약 queueCapacity의 큐가 모두 사용중이라면 , maxPoolSize만큼 스레드를 증설한다.
    @Bean(name = "excelAsyncExecutor")
    public Executor getAsyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5); // 기본 스레드 수
        executor.setMaxPoolSize(20); // 최대 스레드 수
        executor.setQueueCapacity(50); // 스레드풀의 작업큐 크기
        executor.setThreadNamePrefix("InterlockMig-Async-"); // Thread 접두사
        return executor;
    }

}
